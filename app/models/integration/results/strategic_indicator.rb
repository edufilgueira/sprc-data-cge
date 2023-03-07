class Integration::Results::StrategicIndicator < ApplicationDataRecord

  belongs_to :organ,
              -> { where('integration_supports_organs.orgao_sfp = ? AND integration_supports_organs.data_termino IS NULL', false) },
              class_name: 'Integration::Supports::Organ'

  belongs_to :axis,
              class_name: 'Integration::Supports::Axis'

  validates :eixo,
            :indicador,
            :sigla_orgao,
            :organ,
            :axis,
            presence: true

  delegate :title, to: :organ, prefix: true, allow_nil: true
  delegate :sigla, to: :organ, prefix: true, allow_nil: true
  delegate :title, to: :axis, prefix: true

end
