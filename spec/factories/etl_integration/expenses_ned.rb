FactoryBot.define do
  factory :etl_integration_expenses_ned, class: 'EtlIntegration::ExpensesNed' do
    codcontrato { nil }
    modalidade { "ESTIMATIVO" }
    codigo { "2022NE00001" }
    codigodocalterado { nil }
    codprocesso { "SEM PROCESSO" }
    statusdocumento { "CONTABILIZADO" }
    codigoug { "191011" }
    nomeug { "ENCARGOS GERAIS DO ESTADO" }
    codigogestao { nil }
    codfonte { "101" }
    codnatureza { nil }
    codigocredor { nil }
    nomecredor { nil }
    dataemissao { Date.today }
    datacancelamento { nil }
    datacontabilizacao {  }
    valor { 8690540.57 }
    observacao { "PAGAMENTO DA AMORTIZAÇÃO DA DIVIDA EXTERNA - JANEIRO/2022-SÃO JOSE II-7387 - 2ª FASE" }
    tipoalteracao { "NENHUMA" }
    codclassificacao { "4.6.90.71.40000000.001.01.28.844.  212.00002.0.1.01.0.000000.  15. 6.  0.       0.         0.0000000000.0000000000.0000000000.0000000000" }
    coddetalhamentofonte { nil }
    codparcela { nil }
  
  end
end
