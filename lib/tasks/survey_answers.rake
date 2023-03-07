#
# Rake para gerar CSV das pesquisas de satisfação de transparência.
#
# TODO REMOVER
namespace :survey_answers do
  task :generate => :environment do

    file = ENV['file'] || "/tmp/pesquisa.csv"

    puts "Gerando #{file}..."

    CSV.open(file, "wb", row_sep: "\n", col_sep: ";", quote_char: '"', force_quotes: true) do |csv|
      csv << ['Data','Satisfeito?','Email','Mensagem','Url']

      # Transparency::SurveyAnswer.where(created_at: Date.parse('04/09/2018')..Date.parse('12/09/2018')).each {|sa| csv << [I18n.l(sa.date), sa.answer_no? ? 'Não' : 'Sim', sa.email, sa.message, sa.url]}
      Transparency::SurveyAnswer.all.each {|sa| csv << [I18n.l(sa.date), sa.answer_no? ? 'Não' : 'Sim', sa.email, sa.message, sa.url]}
    end
  end

  namespace :calcule_evaluation_note do
    task create_or_update: :environment do

      Transparency::SurveyAnswer.all.each do |survey_answer|
        survey_answer.update_column(:evaluation_note, parse_answer(survey_answer.answer))
      end
    end

    def parse_answer(answer)
      parser = {
        very_dissatisfied: 1,
        somewhat_dissatisfied: 2,
        neutral: 3,
        somewhat_satisfied: 4,
        very_satisfied: 5
      }

      parser[answer&.to_sym]
    end
  end
end
