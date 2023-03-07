class AddIndexIsoCoDtSfpToIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_supports_organs, [:codigo_orgao, :data_termino, :orgao_sfp], name: 'index_iso_co_dt_sfp'
  end
end
