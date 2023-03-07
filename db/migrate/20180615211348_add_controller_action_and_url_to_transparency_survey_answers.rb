class AddControllerActionAndUrlToTransparencySurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :transparency_survey_answers, :controller, :string
    add_index :transparency_survey_answers, :controller
    add_column :transparency_survey_answers, :action, :string
    add_index :transparency_survey_answers, :action
    add_column :transparency_survey_answers, :url, :text
  end
end
