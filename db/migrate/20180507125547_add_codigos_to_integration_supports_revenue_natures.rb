class AddCodigosToIntegrationSupportsRevenueNatures < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_revenue_natures, :codigo_consolidado, :string
    add_index :integration_supports_revenue_natures, :codigo_consolidado, name: :isrn_codigo_consolidado
    add_column :integration_supports_revenue_natures, :codigo_categoria_economica, :string
    add_index :integration_supports_revenue_natures, :codigo_categoria_economica, name: :isrn_codigo_categoria_economica
    add_column :integration_supports_revenue_natures, :codigo_origem, :string
    add_index :integration_supports_revenue_natures, :codigo_origem, name: :isrn_codigo_origem
    add_column :integration_supports_revenue_natures, :codigo_subfonte, :string
    add_index :integration_supports_revenue_natures, :codigo_subfonte, name: :isrn_codigo_subfonte
    add_column :integration_supports_revenue_natures, :codigo_rubrica, :string
    add_index :integration_supports_revenue_natures, :codigo_rubrica, name: :isrn_codigo_rubrica
    add_column :integration_supports_revenue_natures, :codigo_alinea, :string
    add_index :integration_supports_revenue_natures, :codigo_alinea, name: :isrn_codigo_alinea
    add_column :integration_supports_revenue_natures, :codigo_subalinea, :string
    add_index :integration_supports_revenue_natures, :codigo_subalinea, name: :isrn_codigo_subalinea
  end
end
