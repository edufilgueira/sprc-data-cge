class CreateIntegrationSupportsApplicationModalities < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_application_modalities do |t|
      t.string :codigo_modalidade
      t.string :titulo
    end
    add_index :integration_supports_application_modalities, :codigo_modalidade, name: :isam_codigo_modalidade
  end
end
