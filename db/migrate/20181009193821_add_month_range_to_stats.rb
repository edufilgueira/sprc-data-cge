class AddMonthRangeToStats < ActiveRecord::Migration[5.0]
  def change
    add_column :stats, :month_start, :integer
    add_column :stats, :month_end, :integer

    add_index :stats, [:year, :type, :month]
    add_index :stats, [:year, :type, :month_start, :month_end]
  end
end
