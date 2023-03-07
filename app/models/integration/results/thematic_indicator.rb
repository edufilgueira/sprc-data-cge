class Integration::Results::ThematicIndicator < ApplicationDataRecord

  belongs_to :organ,
              -> { where('integration_supports_organs.orgao_sfp = ? AND integration_supports_organs.data_termino IS NULL', false) },
              class_name: 'Integration::Supports::Organ'

  belongs_to :axis,
              class_name: 'Integration::Supports::Axis'

  belongs_to :theme,
              class_name: 'Integration::Supports::Theme'

  validates :eixo,
            :tema,
            :indicador,
            :sigla_orgao,
            :organ,
            :axis,
            :theme,
            presence: true

  delegate :title, to: :organ, prefix: true, allow_nil: true
  delegate :sigla, to: :organ, prefix: true, allow_nil: true
  delegate :title, to: :axis, prefix: true
  delegate :title, to: :theme, prefix: true

end
