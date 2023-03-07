require 'rails_helper'

describe Integration::Expenses::Dailies::CreateStats do

  let(:undefined_daily_message) do
    I18n.t('messages.content.undefined')
  end

  let(:year) { Date.today.year }
  let(:month) { Date.today.month }
  let(:date) { Date.today.beginning_of_month }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO') }

  let(:base_daily_data) do
    {
      valor: 500
    }
  end

  let(:base_daily_anulacao_data) do
    {
      valor: 1,
      natureza: 'ANULACAO',
      npd_ordinaria: first_daily
    }
  end

  let(:first_daily) do
    first = create(:integration_expenses_daily, base_daily_data)
    first_nld = first.nld
    first_ned = first_nld.ned

    first.management_unit = management_unit
    first_nld.management_unit = management_unit
    first_ned.management_unit = management_unit
    first.save
    first_nld.save
    first_ned.save

    first
  end

  let(:second_daily) do
    second = create(:integration_expenses_daily, base_daily_data)
    second_nld = second.nld
    second_ned = second_nld.ned

    second.management_unit = management_unit
    second_nld.management_unit = management_unit
    second_ned.management_unit = management_unit
    second.save
    second_nld.save
    second_ned.save

    second
  end

  let(:third_daily_anulacao) do
    third = create(:integration_expenses_daily, base_daily_anulacao_data)
    third_nld = third.nld
    third_ned = third_nld.ned

    third.management_unit = management_unit
    third_nld.management_unit = management_unit
    third_ned.management_unit = management_unit
    third.save
    third_nld.save
    third_ned.save

    third
  end

  describe 'data' do
    it 'total' do
      first_daily
      second_daily
      third_daily_anulacao

      ignored_out_of_range = create(:integration_expenses_daily, base_daily_data.merge({exercicio: year - 2.years}))

      expected_data = {
        total: {
          calculated_valor_final: 999,
          count: 2
        }
      }

      Integration::Expenses::Dailies::CreateStats.call(year, 0)

      generated = Stats::Expenses::Daily.find_by(year: year, month: 0)

      expect(generated.data[:total]).to eq(expected_data[:total])
    end

    it 'management_unit' do
      first_daily
      second_daily
      third_daily_anulacao

      expected_data = {
        management_unit: {
          management_unit.codigo => {
            title: management_unit.title,
            calculated_valor_final: 999,
            count: 2
          }
        }
      }

      Integration::Expenses::Dailies::CreateStats.call(year, 0)

      generated = Stats::Expenses::Daily.find_by(year: year, month: 0)

      expect(generated.data[:management_unit][management_unit.codigo]).to eq(expected_data[:management_unit][management_unit.codigo])
    end

    it 'creditor' do
      creditor = create(:integration_supports_creditor, nome: 'CREDOR')

      first_daily.creditor = creditor
      second_daily.creditor = creditor
      first_daily.save
      second_daily.save
      third_daily_anulacao

      expected_data = {
        creditor: {
          creditor.nome => {
            title: creditor.nome,
            calculated_valor_final: 999,
            count: 2
          }
        }
      }

      Integration::Expenses::Dailies::CreateStats.call(year, 0)

      generated = Stats::Expenses::Daily.find_by(year: year, month: 0)

      expect(generated.data[:creditor][creditor.nome]).to eq(expected_data[:creditor][creditor.nome])
    end
  end
end
