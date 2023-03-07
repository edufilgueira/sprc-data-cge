class AddUniqueIdsToIntegrationSupportsRevenueNatures < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_supports_revenue_natures, :unique_id_consolidado, :string
    add_index :integration_supports_revenue_natures, :unique_id_consolidado, name: :isrn_unique_id_consolidado
    add_column :integration_supports_revenue_natures, :unique_id_categoria_economica, :string
    add_index :integration_supports_revenue_natures, :unique_id_categoria_economica, name: :isrn_unique_id_categoria_economica
    add_column :integration_supports_revenue_natures, :unique_id_origem, :string
    add_index :integration_supports_revenue_natures, :unique_id_origem, name: :isrn_unique_id_origem
    add_column :integration_supports_revenue_natures, :unique_id_subfonte, :string
    add_index :integration_supports_revenue_natures, :unique_id_subfonte, name: :isrn_unique_id_subfonte
    add_column :integration_supports_revenue_natures, :unique_id_rubrica, :string
    add_index :integration_supports_revenue_natures, :unique_id_rubrica, name: :isrn_unique_id_rubrica
    add_column :integration_supports_revenue_natures, :unique_id_alinea, :string
    add_index :integration_supports_revenue_natures, :unique_id_alinea, name: :isrn_unique_id_alinea
    add_column :integration_supports_revenue_natures, :unique_id_subalinea, :string
    add_index :integration_supports_revenue_natures, :unique_id_subalinea, name: :isrn_unique_id_subalinea

    remove_index :integration_supports_revenue_natures, :unique_id
    remove_column :integration_supports_revenue_natures, :unique_id, :string
  end
end
