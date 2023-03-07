require 'rails_helper'

describe Integration::Expenses::Neds::CreateStats do

  let(:undefined_message) do
    I18n.t('messages.content.undefined')
  end

  let(:year) { Date.today.year }
  let(:month) { Date.today.month }
  let(:date) { Date.today.beginning_of_month }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO') }
  let(:another_management_unit) { create(:integration_supports_organ, orgao_sfp: false, poder: 'EXECUTIVO', descricao_orgao: 'another', codigo_orgao: management_unit.codigo, data_termino: Date.yesterday) }

  let(:base_ned_data) do
    {
      data_emissao: date,
      valor: 500,
      management_unit: management_unit
    }
  end

  let(:first_ned) { create(:integration_expenses_ned, base_ned_data) }

  before do
    create(:integration_expenses_ned, base_ned_data)

    nld_data = base_ned_data.merge({
       ned: first_ned,
       exercicio_restos_a_pagar: first_ned.exercicio,
       unidade_gestora: first_ned.unidade_gestora,
       numero_nota_empenho_despesa: first_ned.numero
    })

    nld = create(:integration_expenses_nld, nld_data)

    create(:integration_expenses_npd, base_ned_data.merge({ exercicio: nld.exercicio, numero_nld_ordinaria: nld.numero, valor: 200 }))

    create(:integration_expenses_ned, base_ned_data.merge({exercicio: year - 2.years}))
  end

  describe 'data' do
    it 'total' do
      ned_data = base_ned_data

      create(:integration_expenses_ned, ned_data.merge({exercicio: year - 2.years}))

      expected_data = {
        total: {
          calculated_valor_final: 1000,
          calculated_valor_pago_final: 200,
          count: 2
        }
      }

      Integration::Expenses::Neds::CreateStats.call(year, 0)

      generated = Stats::Expenses::Ned.find_by(year: year, month: 0)

      expect(generated.data[:total]).to eq(expected_data[:total])
    end

    it 'management_unit' do
      # Testa para ver se não duplica unidades com mesmo código
      another_management_unit

      ned_data = base_ned_data.merge({
        management_unit: management_unit,
        unidade_gestora: 1234
      })

      first_ned.update(ned_data)
      create(:integration_expenses_ned, ned_data)

      expected_data = {
        management_unit: {
          management_unit.codigo => {
            title: management_unit.title,
            calculated_valor_final: 1000,
            calculated_valor_pago_final: 200,
            count: 2
          }
        }
      }

      Integration::Expenses::Neds::CreateStats.call(year, month)

      generated = Stats::Expenses::Ned.find_by(year: year, month: month)

      expect(generated.data[:management_unit][management_unit.codigo][:valor]).to eq(expected_data[:management_unit][management_unit.codigo][:valor])
      expect(generated.data[:management_unit][another_management_unit.title]).to eq(nil)
    end

    it 'razao_social_credor' do
      razao_social_credor_title = 'CREDOR'

      ned_data = base_ned_data.merge({
        razao_social_credor: razao_social_credor_title
      })

      first_ned.update(ned_data)
      create(:integration_expenses_ned, ned_data)

      expected_data = {
        razao_social_credor: {
          razao_social_credor_title => {
            calculated_valor_final: 1000,
            calculated_valor_pago_final: 200,
            count: 2
          },

          undefined_message => {
            calculated_valor_final: 500,
            calculated_valor_pago_final: 100,
            count: 1
          }
        }
      }

      Integration::Expenses::Neds::CreateStats.call(year, month)

      generated = Stats::Expenses::Ned.find_by(year: year, month: month)

      expect(generated.data[:razao_social_credor][razao_social_credor_title]).to eq(expected_data[:razao_social_credor][razao_social_credor_title])
     end

    it 'expense_element' do
      first = create(:integration_expenses_ned, base_ned_data)
      second = create(:integration_expenses_ned, base_ned_data)

      expense_element = create(:integration_supports_expense_element, codigo_elemento_despesa: first.classificacao_elemento_despesa)


      expect(first.reload.expense_element).to eq(expense_element)

      expected_data = {
        expense_element: {
          expense_element.codigo_elemento_despesa => {
            title: expense_element.title,
            calculated_valor_final: 1000,
            calculated_valor_pago_final: 200,
            count: 2
          }
        }
      }

      Integration::Expenses::Neds::CreateStats.call(year, month)

      generated = Stats::Expenses::Ned.find_by(year: year, month: month)

      expect(generated.data[:expense_element][expense_element.codigo_elemento_despesa][:valor]).to eq(expected_data[:expense_element][expense_element.codigo_elemento_despesa][:valor])
    end
  end
end
