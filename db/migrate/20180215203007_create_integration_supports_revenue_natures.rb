class CreateIntegrationSupportsRevenueNatures < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_revenue_natures do |t|
      t.string :codigo
      t.string :descricao
    end
    add_index :integration_supports_revenue_natures, :codigo, name: :isrn_codigo
  end
end
