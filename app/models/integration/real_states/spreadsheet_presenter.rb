class Integration::RealStates::SpreadsheetPresenter

  COLUMNS = [
    :service_id,
    :descricao_imovel,
    :property_type_title,
    :occupation_type_title,
    :estado,
    :municipio,
    :area_projecao_construcao,
    :area_medida_in_loco,
    :area_registrada,
    :frente,
    :fundo,
    :lateral_direita,
    :lateral_esquerda,
    :taxa_ocupacao,
    :fracao_ideal,
    :numero_imovel,
    :utm_zona,
    :bairro,
    :cep,
    :endereco,
    :complemento,
    :lote,
    :quadra
  ].freeze

  attr_reader :real_state

  def initialize(real_state)
    @real_state = real_state
  end

  def self.spreadsheet_header
    columns.map do |column|
      spreadsheet_header_title(column)
    end
  end

  def spreadsheet_row
    columns.map do |column|
      real_state.send(column).to_s
    end
  end

  private

  def self.spreadsheet_header_title(column)
    Integration::RealStates::RealState.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
