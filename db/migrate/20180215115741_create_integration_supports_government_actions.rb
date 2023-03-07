class CreateIntegrationSupportsGovernmentActions < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_government_actions do |t|
      t.string :codigo_acao
      t.string :titulo
    end
    add_index :integration_supports_government_actions, :codigo_acao, name: :isga_codigo_acao
  end
end
