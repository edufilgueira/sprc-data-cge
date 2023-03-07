class OpenData::Importer
  include BaseIntegrationsImporter

  attr_reader :client, :data_item

  def self.call(data_item_id)
    new(data_item_id).call
  end

  def initialize(data_item_id)
    @data_item = OpenData::DataItem.find(data_item_id)

    # O BaseIntegrationsImporter tem vários métodos compartilhados, mas usa o
    # conceito dos Configuration para acessar as configurações. Como os métodos
    # de Configuration e Importer que serão usados são compatíveis, podemos
    # passar o importer como @configuration.
    @configuration = @importer

    @client = client_connection(@data_item.wsdl, @data_item.headers_soap_action)
  end

  def call
    begin
      import
    rescue Savon::SOAPFault, EOFError, Net::ReadTimeout => e
      last_error = e.message
      save_data_item(:status_fail, last_error)
    end
  end

  private

  def import
    if data_item.webservice?
      save_data_item(:status_in_progress)

      generate_csv

      data_item.document_filename = document_filename

      save_data_item(:status_success)
    end
  end

  def save_data_item(status, last_error = nil)
    data_item.update_attributes({
      processed_at: DateTime.now,
      status: status,
      last_error: last_error
    })
  end

  def resources
    @resources ||= resource_from_type
  end

  def resource_from_type
    result = resource_from_path

    result.is_a?(Array) ? result : resource_from_dataset(result)
  end

  def resource_from_dataset(dataset)
    hash = Hash.from_xml(dataset)

    if hash.present?
      hash['NewDataSet']['Table']
    end
  end

  def resource_from_path
    response_path.inject(body) { |result, key| result.present? ? result[key] : nil }
  end

  def response_path
    data_item.response_path.split('/').map(&:to_sym)
  end

  def operation(prefix=nil)
    data_item.operation.to_sym
  end

  def current_month
    Date.current.month
  end

  def formatted_date
    Date.current.strftime('%Y_%m_%d')
  end

  def message
    Rack::Utils.parse_nested_query(message_without_placeholder)
  end

  def message_without_placeholder
    msg = data_item.parameters || ""

    msg.gsub('CURRENT_MONTH', current_month.to_s)
  end

  def data_item_name
    @data_item.document_public_filename.gsub(/\s/, '_').downcase
  end

  def header
    return [] unless resources.present?

    flatten_hash(resources.first).keys
  end

  def document_content(csv)
    StringIO.new(csv) if csv.present?
  end

  def flatten_hash(hash)
    hash.deep_stringify_keys.each_with_object({}) do |(k, v), h|
      if v.is_a? Hash
        flatten_hash(v).map do |h_k, h_v|
          h["#{h_k}"] = h_v
        end
      else
        h[k] = v
      end
    end
  end

  def spreadsheet_dir_path
    Rails.root.to_s + "/public/files/downloads/integration/open_data/data_items/#{data_item.id}"
  end

  def spreadsheet_file_path
    "#{spreadsheet_dir_path}/#{document_filename}"
  end

  def document_filename
    "importacao_#{data_item_name}_#{formatted_date}.csv"
  end

  def create_dir
    FileUtils.rm_rf(spreadsheet_dir_path) if File.exist?(spreadsheet_dir_path)
    FileUtils.mkdir_p(spreadsheet_dir_path)
  end

  def generate_csv
    return unless resources.present?

    create_dir

    CSV.open(spreadsheet_file_path, "w") do |csv|
      csv << header

      resources.each do |row|
        values = flatten_hash(row)
        csv << header.map { |field| values[field] }
      end
    end
  end
end
