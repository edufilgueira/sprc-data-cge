class CreateTransparencySurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :transparency_survey_answers do |t|
      t.string :transparency_page
      t.integer :answer
      t.date :date

      t.timestamps
    end
    add_index :transparency_survey_answers, :transparency_page, name: :tsa_transparency_page
    add_index :transparency_survey_answers, :answer, name: :tsa_answer
    add_index :transparency_survey_answers, :date, name: :tsa_date
  end
end
