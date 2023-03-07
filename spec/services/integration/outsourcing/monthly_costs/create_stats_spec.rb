require 'rails_helper'

describe Integration::Outsourcing::MonthlyCosts::CreateStats do
  describe 'verify stats' do

    let(:year) { Date.today.year }
    let(:month) { Date.today.month }

    let(:base_outsourcing_monthly_cost_data) do
      [
        {
          nome: 'Profissional 1',
          competencia: "#{month.to_s.rjust(2, '0')}/#{year}",
          month_import: "#{month}/#{year}",
          orgao: 'SEPLAG',
          isn_entidade: '1',
          vlr_custo_total: '2000',
          vlr_salario_base: '1000',
          vlr_adicional: '0',
          vlr_adicional_noturno: '0',
          vlr_insalubridade: '0',
          vlr_periculosidade: '0',
          vlr_vale_transporte: '0',
          vlr_vale_refeicao: '0',
          vlr_cesta_basica: '0',
          vlr_hora_extra: '0',
          vlr_dsr: '0',
          cpf: '123456678910',
          categoria: 'A1',
          numerocontrato: '1000',
          remuneracao: '1000',
        },
        {
          nome: 'Profissional 2',
          competencia: "#{month.to_s.rjust(2, '0')}/#{year}",
          month_import: "#{month}/#{year}",
          orgao: 'SEPLAG',
          isn_entidade: '1',
          vlr_custo_total: '10000',
          vlr_salario_base: '1500',
          vlr_adicional: '1500',
          vlr_adicional_noturno: '0',
          vlr_insalubridade: '500',
          vlr_periculosidade: '0',
          vlr_vale_transporte: '0',
          vlr_vale_refeicao: '0',
          vlr_cesta_basica: '0',
          vlr_hora_extra: '0',
          vlr_dsr: '0',
          cpf: '123456678911',
          categoria: 'A1',
          numerocontrato: '1001',
          remuneracao: '7000',
        },
        {
          nome: 'Profissional 3',
          competencia: "#{month.to_s.rjust(2, '0')}/#{year}",
          month_import: "#{month}/#{year}",
          orgao: 'CGE',
          isn_entidade: '2',
          vlr_custo_total: '15000',
          vlr_salario_base: '2500',
          vlr_adicional: '10',
          vlr_adicional_noturno: '10',
          vlr_insalubridade: '10',
          vlr_periculosidade: '10',
          vlr_vale_transporte: '10',
          vlr_vale_refeicao: '10',
          vlr_cesta_basica: '10',
          vlr_hora_extra: '10',
          vlr_dsr: '10',
          cpf: '123456678912',
          categoria: 'A2',
          numerocontrato: '1002',
          remuneracao: '10590',
        }
      ]
    end


    describe 'data field' do

      before do
        base_outsourcing_monthly_cost_data.map {
          |monthly_cost_data| Integration::Outsourcing::MonthlyCost.new(monthly_cost_data).save
        }
        Integration::Outsourcing::MonthlyCosts::CreateStats.call(year, month)

      end

      it 'record integrity' do
        expect(Integration::Outsourcing::MonthlyCost.count).to eq(3)
        expect(Stat.count).to eq(1)
        expect(Stat.first.type).to eq('Stats::Outsourcing::MonthlyCost')
      end

      it 'total stat' do
        result_data_total =
          {
            total_cost: 27000,
            total_outsourcing: 3,
            total_salaries: 18590,
            total_net_cost: 8410,
          }
        expect(Stat.first.data[:total]).to eq(result_data_total)
      end

      it 'organ stat' do

        result_data_organ =
          {
            SEPLAG: {
              count: 2,
              total: 12000,
              title: 'SEPLAG'
            },
            CGE: {
              count: 1,
              total: 15000,
              title: 'CGE'
            }
          }
        expect(Stat.first.data[:organ]).to eq(result_data_organ)

      end

      it 'office stat' do

        result_data_office =
          {
            A1: {
              count: 2,
              total: 12000,
              title: 'A1'
            },
            A2: {
              count: 1,
              total: 15000,
              title: 'A2'
            }
          }
        expect(Stat.first.data[:category]).to eq(result_data_office)

      end
    end
  end
end
