#
# Representa a pesquisa de satisfação de transparência
#
class Transparency::SurveyAnswer < ApplicationDataRecord

  # Callbacks

  after_validation :calcule_evaluation_note

  # Enumerations

  enum answer: {
    very_dissatisfied: 1,
    somewhat_dissatisfied: 3,
    neutral: 2,
    somewhat_satisfied: 4,
    very_satisfied: 0
  }

  # Validations

  ## Presence

  validates :transparency_page,
    :answer,
    :date,
    :email,
    :message,
    :controller,
    :action,
    :url,
    presence: true


  private

  def calcule_evaluation_note
    self.evaluation_note = parse_answer
  end

  def parse_answer
    parser = {
      very_dissatisfied: 1,
      somewhat_dissatisfied: 2,
      neutral: 3,
      somewhat_satisfied: 4,
      very_satisfied: 5
    }

    parser[self.answer&.to_sym]
  end

end
