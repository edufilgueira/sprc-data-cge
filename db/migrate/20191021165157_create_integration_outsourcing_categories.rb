class CreateIntegrationOutsourcingCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_outsourcing_categories do |t|
      t.string :description

      t.timestamps
    end

    add_index :integration_outsourcing_categories, :description

  end
end
