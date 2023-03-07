class Integration::Eparcerias::Importer
  include BaseIntegrationsImporter

  BASE_WORK_PLAN_ATTACHMENTS_PATH =
    'public/files/downloads/integration/eparcerias/work_plan_attachments'

  attr_reader :client, :configuration, :import_all

  def self.call(configuration_id)
    new(configuration_id).call
  end

  def initialize(configuration_id)
    @configuration = Integration::Eparcerias::Configuration.find(configuration_id)
    @client = client_connection(@configuration.wsdl, @configuration.headers_soap_action, false)
    @current_convenant = nil

    @import_all = @configuration.import_all?
  end

  def call
    start

    begin
      import

      close_log

      @configuration.status_success!

    rescue StandardError => e
      log(:error, I18n.t('services.importer.log.error', e: e.message))
      close_log
      @configuration.status_fail!
    end
  end

  def convenants
    base_scope = Integration::Contracts::Convenant.order('isn_sic DESC')
    if import_all?
      base_scope.all
    else
      base_scope.active_on_month(Date.today)
    end
  end

  private

  # Overrides de Base

  def message(prefix)
    if prefix == :work_plan_attachment
      default_message.merge({numero_plano_trabalho: @current_convenant.cod_plano_trabalho})
    else
      default_message.merge({numero_instrumento: @current_convenant.isn_sic})
    end
  end

  # O serviço explode quando não têm o convênio que estamos buscando.
  # Devemos apenas ignorar esses casos.
  def response(prefix=nil)
    begin
      result = super
    rescue Savon::SOAPFault => e
      log(:error, "Problema ao importar convênio: #{@current_convenant.isn_sic} / #{prefix} / #{e.message}")
      result = nil
    else
      log(:info, "Importando convênio: #{@current_convenant.isn_sic} / #{prefix}")
    end

    result
  end

  def import
    line = 0

    convenants.each do |convenant|
      line += 1

      kinds.each do |kind|
        resources(kind, convenant).each do |attributes|
          send("save_#{kind}", convenant, attributes)
        end
      end
    end

    log(:info, I18n.t("services.importer.log.eparcerias", line: line))
  end

  def resources(prefix, convenant)
    @current_convenant = convenant
    super(prefix)
  end

  def save_transfer_bank_order(convenant, attributes)
    return unless attributes.present?

    transfer_bank_order =
      Integration::Eparcerias::TransferBankOrder.find_or_initialize_by(isn_sic: convenant.isn_sic, numero_ordem_bancaria: attributes[:numero_ordem_bancaria])

    if !transfer_bank_order.convenant.try(:confidential?)
      transfer_bank_order.update_attributes!(attributes)
    end
  end

  def save_work_plan_attachment(convenant, attributes)
    return unless attributes.present?

    work_plan_attachment =
      Integration::Eparcerias::WorkPlanAttachment.find_or_initialize_by(isn_sic: convenant.isn_sic, file_name: attributes[:file_name])

    # Temos que gravar o conteúdo do arquivo no filysystem e remover esse
    # atributo.

    file_content = attributes.delete(:file_content)
    
    if (work_plan_attachment.convenant.present? and
      !work_plan_attachment.convenant.confidential? and 
      work_plan_attachment.update_attributes!(attributes))

      write_work_plan_file(work_plan_attachment, file_content)
    end
  end

  def save_accountability(convenant, status)
    # status blank vem de resources como [{}].

    if status.present?
      convenant.update_attributes!({ accountability_status: status })
    else
      convenant.update_attributes!({ accountability_status: nil })
    end
  end

  def kinds
    [:transfer_bank_order, :accountability]
  end

  def write_work_plan_file(work_plan_attachment, file_content)
    create_work_plan_dir(work_plan_attachment)

    file_path =  work_plan_file_path(work_plan_attachment)

    File.open(file_path, "w+:ASCII-8BIT") do |f|
      f.write(Base64.decode64(file_content)) if file_content.present?
    end
  end

  def create_work_plan_dir(work_plan_attachment)
    dir_path = work_plan_dir_path(work_plan_attachment)

    FileUtils.rm_rf(dir_path.to_s) if File.exist?(dir_path.to_s)
    FileUtils.mkdir_p(dir_path.to_s)
  end

  def work_plan_file_path(work_plan_attachment)
    "#{work_plan_dir_path(work_plan_attachment)}/#{work_plan_attachment.file_name}"
  end

  def work_plan_dir_path(work_plan_attachment)
    File.join(Rails.root, BASE_WORK_PLAN_ATTACHMENTS_PATH, work_plan_attachment.id.to_s)
  end

  def import_all?
    @import_all
  end
end
