class CreateIntegrationSupportsRealStatesOccupationTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_supports_real_states_occupation_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
