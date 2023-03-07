class CreateIntegrationContractsTransferBankOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_contracts_transfer_bank_orders do |t|
      t.integer :isn_sic
      t.string :numero_ordem_bancaria
      t.string :tipo_ordem_bancaria
      t.string :nome_benceficiario
      t.datetime :data_pagamento
      t.decimal :valor_ordem_bancaria, precision: 12, scale: 2
    end

    add_index :integration_contracts_transfer_bank_orders, :isn_sic, name: :ictbo_isn_sic
    add_index :integration_contracts_transfer_bank_orders, :numero_ordem_bancaria, name: :ictbo_numero_ordem_bancaria
    add_index :integration_contracts_transfer_bank_orders, :tipo_ordem_bancaria, name: :ictbo_tipo_ordem_bancaria
  end
end
