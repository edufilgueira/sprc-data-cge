class AddEvaluationNoteToTransparencySurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :transparency_survey_answers, :evaluation_note, :integer
  end
end
