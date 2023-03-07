class ChangeExercicioToIntegerInNldsAndNpds < ActiveRecord::Migration[5.0]
  def up
    change_column :integration_expenses_nlds, :exercicio, 'integer USING CAST(exercicio AS integer)'
    change_column :integration_expenses_npds, :exercicio, 'integer USING CAST(exercicio AS integer)'
  end

  def down
    change_column :integration_expenses_nlds, :exercicio, :string
    change_column :integration_expenses_npds, :exercicio, :string
  end
end
