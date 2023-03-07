class CreateIntegrationSupportsQualifiedResourceSources < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_qualified_resource_sources do |t|
      t.string :codigo
      t.string :titulo
    end
    add_index :integration_supports_qualified_resource_sources, :codigo, name: :isqrs_codigo
  end
end
