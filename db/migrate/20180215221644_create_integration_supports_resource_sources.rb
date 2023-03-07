class CreateIntegrationSupportsResourceSources < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_resource_sources do |t|
      t.string :codigo_fonte
      t.string :titulo
    end
    add_index :integration_supports_resource_sources, :codigo_fonte, name: :isrs_codigo_fonte
  end
end
