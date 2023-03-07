class CreateIntegrationOutsourcingMonthlyCost < ActiveRecord::Migration[5.0]
  def change
    create_table :integration_outsourcing_monthly_costs do |t|
      t.string :numerocontrato
      t.string :competencia
      t.string :nome
      t.string :cpf
      t.string :orgao
      t.string :categoria
      t.string :data_inicio
      t.string :data_termino
      t.string :tipo_servico
      t.string :situacao
      t.integer :dias_trabalhados
      t.integer :qtd_hora_extra
      t.decimal :vlr_hora_extra
      t.integer :qtd_diarias
      t.decimal :vlr_diarias
      t.decimal :vlr_vale_transporte
      t.decimal :vlr_vale_refeicao
      t.decimal :vlr_salario_base
      t.decimal :vlr_custo_total
      t.string :month_import
      t.timestamps
    end

    add_index :integration_outsourcing_monthly_costs, :orgao
    add_index :integration_outsourcing_monthly_costs, :month_import
    add_index :integration_outsourcing_monthly_costs, :categoria
  end
end
