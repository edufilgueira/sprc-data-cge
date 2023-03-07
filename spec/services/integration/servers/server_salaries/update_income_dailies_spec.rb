require 'rails_helper'

describe Integration::Servers::ServerSalaries::UpdateIncomeDailies do

  describe 'call' do

    describe 'update_income_dailies' do
      it 'with month_year_str valid' do
        month = '01/2019'
        date = month.to_date

        server_salary = create(:integration_servers_server_salary, date: date)
        registration = server_salary.registration
        organ = registration.organ

        daily = create(:integration_expenses_daily, data_emissao: date.to_s, documento_credor: registration.dsc_cpf)
        daily.update(unidade_gestora: organ.codigo_orgao)

        Integration::Servers::ServerSalaries::CreateStats.call(date.year, date.month)

        service = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(month, nil, false, true)

        service.call

        server_salary.reload

        expected = daily.valor

        expect(server_salary.income_dailies).to eq(expected)
      end

      it 'with month_year_str = 0' do
        month = '01/2019'
        date = month.to_date

        server_salary = create(:integration_servers_server_salary, date: date)
        registration = server_salary.registration
        organ = registration.organ

        daily = create(:integration_expenses_daily, data_emissao: date.to_s, documento_credor: registration.dsc_cpf)
        daily.update(unidade_gestora: organ.codigo_orgao)

        Integration::Servers::ServerSalaries::CreateStats.call(date.year, date.month)

        service = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(0, nil, false, false)

        service.call

        expected = daily.valor

        expect(server_salary.income_dailies).to_not eq(expected)
      end

      it 'with cpf' do
        month = '01/2019'
        date = month.to_date

        server_salary = create(:integration_servers_server_salary, date: date)
        registration = server_salary.registration
        organ = registration.organ
        cpf = registration.dsc_cpf

        daily = create(:integration_expenses_daily, data_emissao: date.to_s, documento_credor: cpf)
        daily.update(unidade_gestora: organ.codigo_orgao)

        Integration::Servers::ServerSalaries::CreateStats.call(date.year, date.month)

        service = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(month, cpf, false, false)

        service.call

        expected = daily.valor

        expect(server_salary.income_dailies).to_not eq(expected)
      end
    end

    describe 'update_all_stats' do
      it 'flag true param' do
        month = '01/2019'
        date = month.to_date

        Integration::Servers::ServerSalaries::CreateStats.call(date.year, date.month)

        service = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(month, nil, true, true)

        allow(Integration::Servers::ServerSalaries::CreateStats).to receive(:call)
        service.call

        expect(Integration::Servers::ServerSalaries::CreateStats).to have_received(:call).with(date.year, date.month).once
      end

      it 'flag false param' do
        month = '01/2019'
        date = month.to_date

        Integration::Servers::ServerSalaries::CreateStats.call(date.year, date.month)

        service = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(month, nil, false, true)

        allow(Integration::Servers::ServerSalaries::CreateStats).to receive(:call)
        service.call

        expect(Integration::Servers::ServerSalaries::CreateStats).to_not have_received(:call)
      end
    end

    describe 'update_all_stats' do
      it 'flag true param' do
        month = '01/2019'
        date = month.to_date

        service = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(month, nil, false, true)

        allow(Integration::Servers::ServerSalaries::CreateSpreadsheet).to receive(:call)
        service.call

        expect(Integration::Servers::ServerSalaries::CreateSpreadsheet).to have_received(:call).with(date.year, date.month).once
      end

      it 'flag false param' do
        month = '01/2019'
        date = month.to_date

        service = Integration::Servers::ServerSalaries::UpdateIncomeDailies.new(month, nil, false, false)

        allow(Integration::Servers::ServerSalaries::CreateSpreadsheet).to receive(:call)
        service.call

        expect(Integration::Servers::ServerSalaries::CreateSpreadsheet).to_not have_received(:call)
      end
    end
  end
end
