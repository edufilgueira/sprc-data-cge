class AddIndexIsoCoDtDfpToIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_supports_organs, [:codigo_orgao, :data_termino, :codigo_folha_pagamento], name: 'index_iso_co_dt_cfp'
  end
end
