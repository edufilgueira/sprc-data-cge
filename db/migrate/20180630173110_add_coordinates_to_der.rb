class AddCoordinatesToDer < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_constructions_ders, :latitude, :string
    add_column :integration_constructions_ders, :longitude, :string
  end
end
