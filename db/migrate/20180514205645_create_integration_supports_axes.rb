class CreateIntegrationSupportsAxes < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_axes do |t|
      t.string :codigo_eixo
      t.string :descricao_eixo
    end
    add_index :integration_supports_axes, :codigo_eixo, name: :ist_codigo_eixo
  end
end
