class AddEmailAndMessageToTransparencySurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :transparency_survey_answers, :email, :string
    add_column :transparency_survey_answers, :message, :text
  end
end
