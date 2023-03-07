class RemoveCodigoWithoutZeroesFromIntegrationSupportsCreditors < ActiveRecord::Migration[5.0]
  def change
    remove_column :integration_supports_creditors, :codigo_without_zeroes, :integer
  end
end
