class AddIndexesToIntegrationSupportsOrgans < ActiveRecord::Migration[5.0]
  def change
    add_index :integration_supports_organs, :codigo_folha_pagamento
    add_index :integration_supports_organs, :codigo_entidade
    add_index :integration_supports_organs, :sigla
  end
end
