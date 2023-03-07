class AddDateOfIssueToExpenseModels < ActiveRecord::Migration[5.0]
  def change
    add_column :integration_expenses_nlds, :date_of_issue, :date
    add_column :integration_expenses_npfs, :date_of_issue, :date
    add_column :integration_expenses_npds, :date_of_issue, :date

    add_index :integration_expenses_nlds, :date_of_issue, name: :ienld_date_of_issue
    add_index :integration_expenses_npfs, :date_of_issue, name: :ienpf_date_of_issue
    add_index :integration_expenses_npds, :date_of_issue, name: :ienpd_date_of_issue
    add_index :integration_expenses_neds, :date_of_issue, name: :iened_date_of_issue
  end
end
