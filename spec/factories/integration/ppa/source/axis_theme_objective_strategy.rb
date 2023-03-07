FactoryBot.define do
  factory :integration_ppa_source_axis_theme_objective_strategy, class: 'Integration::PPA::Source::AxisThemeObjectiveStrategy' do
    ppa_ano_inicio 2020
	ppa_ano_fim '2021'
	eixo_cod '1'
	eixo_descricao 'My Eixo'
	regiao_cod '1'
	regiao_descricao 'My regiao_descricao'
	tema_cod '1'
	tema_descricao 'My tema_descricao'
	objetivo_cod '1'
	estrategia_cod '1'
	estrategia_descricao 'My estrategia_descricao'
	objetivo_descricao 'My objetivo_descricao'
	tema_descricao_detalhada 'My tema_descricao_detalhada'
	eixo_isn 1001
	tema_isn 10001
	regiao_isn 10
	estrategia_isn 100
	objetivo_isn 1000
  end
end
