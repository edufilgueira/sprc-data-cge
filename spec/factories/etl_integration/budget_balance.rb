FactoryBot.define do
  factory :etl_integration_budget_balance, class: 'EtlIntegration::BudgetBalance' do
		classifreduzida { "10622" }
		classificacaoacao { "3" }
		classificacaocompleta { "36000000.006.01.23.695.  371.20622.0.1.00.0.000000.3.3.90.14.  08. 3.  1" }
		codacao { "20622" }
		coddetafonte { "000000" }
		codesfera { "01" }
		codfonte { "100" }
		codfuncao { "23" }
		codiduso { "0" }
		codlocalizadorgasto { "08" }
		codnatureza { "339014" }
		codprograma { "371" }
		codsubfuncao { "695" }
		codug { "360001" }
		coduo { "36100006" }
		nummes { 1 }
		valanulado { 0.0 }
		valcontido { 0.0 }
		valcontidoanulado { 0.0 }
		valdescentralizado { 0.0 }
		valdescentralizadoanulado { 0.0 }
		valempenhado { 100 }
		valempenhadoanulado { 0.0 }
		valinicial { 150 }
		valliquidado { 0.0 }
		valliquidadoanulado { 0.0 }
		valliquidadoretido { 0.0 }
		valliquidadoretidoanulado { 0.0 }
		valpago { 0.0 }
		valpagoanulado { 0.0 }
		valsuplementado { 0.0 }
		valtransferidoconcedido { 0.0 }
		valtransferidorecebido { 0.0 }
		numano { 2022 }

    trait :invalid do
      ano_mes_competencia nil
    end
  end
end
