class AddOrganToImporters < ActiveRecord::Migration[5.0]
  def change
    add_reference(:importers, :organ, foreign_key: { to_table: :integration_supports_organs })
  end
end
