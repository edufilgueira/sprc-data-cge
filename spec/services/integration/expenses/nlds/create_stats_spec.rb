require 'rails_helper'

describe Integration::Expenses::Nlds::CreateStats do

  let(:undefined_message) do
    I18n.t('messages.content.undefined')
  end

  let(:year) { Date.today.year }
  let(:month) { Date.today.month }
  let(:date) { Date.today.beginning_of_month }

  let(:management_unit) { create(:integration_supports_management_unit, poder: 'EXECUTIVO') }

  let(:base_nld_data) do
    {
      data_emissao: date,
      valor: 500,
      management_unit: management_unit
    }
  end

  describe 'data' do
    it 'total' do
      nld_data = base_nld_data

      first = create(:integration_expenses_nld, nld_data)
      second = create(:integration_expenses_nld, nld_data)

      ignored_out_of_range = create(:integration_expenses_nld, nld_data.merge({data_emissao: date - 2.years}))

      expected_data = {
        total: {
          valor: 1000,
          count: 2
        }
      }

      Integration::Expenses::Nlds::CreateStats.call(year, month)

      generated = Stats::Expenses::Nld.find_by(year: year, month: month)

      expect(generated.data[:total]).to eq(expected_data[:total])
    end

    it 'management_unit' do
      nld_data = base_nld_data.merge({
        unidade_gestora: management_unit.codigo
      })

      first = create(:integration_expenses_nld, nld_data)
      second = create(:integration_expenses_nld, nld_data)

      expected_data = {
        management_unit: {
          management_unit.codigo => {
            title: management_unit.title,
            valor: 1000,
            count: 2
          }
        }
      }

      Integration::Expenses::Nlds::CreateStats.call(year, month)

      generated = Stats::Expenses::Nld.find_by(year: year, month: month)

      expect(generated.data[:management_unit][management_unit.codigo]).to eq(expected_data[:management_unit][management_unit.codigo])
    end

    it 'creditor' do
      creditor = create(:integration_supports_creditor, codigo: '00001234')

      nld_data = base_nld_data.merge({
        credor:  '00001234'
      })

      first = create(:integration_expenses_nld, nld_data)
      second = create(:integration_expenses_nld, nld_data)

      undefined_creditor = build(:integration_expenses_nld, nld_data.merge({creditor: nil}))
      undefined_creditor.save(validate: false)

      expected_data = {
        creditor: {
          creditor.title => {
            title: creditor.title,
            valor: 1000,
            count: 2
          },

          undefined_message => {
            valor: 500,
            count: 1
          }
        }
      }

      Integration::Expenses::Nlds::CreateStats.call(year, month)

      generated = Stats::Expenses::Nld.find_by(year: year, month: month)

      expect(generated.data[:creditor][creditor.title]).to eq(expected_data[:creditor][creditor.title])
      expect(generated.data[:creditor][undefined_message]).to eq(expected_data[:creditor][undefined_message])
    end
  end
end
