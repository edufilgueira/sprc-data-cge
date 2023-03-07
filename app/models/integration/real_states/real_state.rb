class Integration::RealStates::RealState < ApplicationDataRecord

  belongs_to :manager,
              -> { where('integration_supports_organs.orgao_sfp = ? AND integration_supports_organs.data_termino IS NULL', false) },
              class_name: 'Integration::Supports::Organ'

  belongs_to :property_type,
              class_name: 'Integration::Supports::RealStates::PropertyType'

  belongs_to :occupation_type,
              class_name: 'Integration::Supports::RealStates::OccupationType'

  validates :municipio,
            :service_id,
            presence: true

  delegate :title, to: :property_type, prefix: true, allow_nil: true
  delegate :title, to: :occupation_type, prefix: true, allow_nil: true
  delegate :title, to: :manager, prefix: true, allow_nil: true

end
