# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210930133312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "icon_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_categories_on_deleted_at", using: :btree
    t.index ["name"], name: "index_categories_on_name", using: :btree
  end

  create_table "gas_vouchers", force: :cascade do |t|
    t.string   "region"
    t.string   "city"
    t.string   "nis"
    t.string   "cpf"
    t.string   "name"
    t.string   "lot_1"
    t.string   "lot_2"
    t.string   "lot_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_gas_vouchers_on_cpf", using: :btree
  end

  create_table "integration_city_undertakings_city_undertakings", force: :cascade do |t|
    t.string   "tipo_despesa"
    t.integer  "sic"
    t.string   "mapp"
    t.string   "municipio"
    t.integer  "expense"
    t.decimal  "valor_programado1"
    t.decimal  "valor_programado2"
    t.decimal  "valor_programado3"
    t.decimal  "valor_programado4"
    t.decimal  "valor_programado5"
    t.decimal  "valor_programado6"
    t.decimal  "valor_programado7"
    t.decimal  "valor_programado8"
    t.decimal  "valor_executado1"
    t.decimal  "valor_executado2"
    t.decimal  "valor_executado3"
    t.decimal  "valor_executado4"
    t.decimal  "valor_executado5"
    t.decimal  "valor_executado6"
    t.decimal  "valor_executado7"
    t.decimal  "valor_executado8"
    t.integer  "sprc_city_id"
    t.integer  "organ_id"
    t.integer  "creditor_id"
    t.integer  "undertaking_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["creditor_id"], name: "index_integration_c_utaking_on_integration_creditor_id", using: :btree
    t.index ["mapp"], name: "city_undertakings_by_mapp", using: :btree
    t.index ["municipio", "mapp", "sic", "undertaking_id"], name: "city_undertakings_by_finder", using: :btree
    t.index ["municipio"], name: "city_undertakings_by_municipio", using: :btree
    t.index ["organ_id"], name: "index_integration_c_utaking_on_integration_s_organs_id", using: :btree
    t.index ["sic"], name: "city_undertakings_by_sic", using: :btree
    t.index ["undertaking_id"], name: "index_integration_c_utaking_on_integration_undertaking_id", using: :btree
  end

  create_table "integration_city_undertakings_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "user"
    t.string   "password"
    t.string   "undertaking_operation"
    t.string   "undertaking_response_path"
    t.string   "city_undertaking_operation"
    t.string   "city_undertaking_response_path"
    t.string   "city_organ_operation"
    t.string   "city_organ_response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.string   "headers_soap_action"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "integration_constructions_configurations", force: :cascade do |t|
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "der_wsdl"
    t.string   "dae_wsdl"
    t.string   "der_operation"
    t.string   "der_response_path"
    t.string   "dae_operation"
    t.string   "dae_response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "der_contract_operation"
    t.string   "der_contract_response_path"
    t.string   "der_measurement_operation"
    t.string   "der_measurement_response_path"
    t.string   "dae_measurement_operation"
    t.string   "dae_measurement_response_path"
    t.string   "dae_photo_operation"
    t.string   "dae_photo_response_path"
    t.string   "der_coordinates_operation"
    t.string   "der_coordinates_response_path"
  end

  create_table "integration_constructions_dae_measurements", force: :cascade do |t|
    t.integer  "integration_constructions_dae_id"
    t.string   "ano_mes"
    t.date     "ano_mes_date"
    t.string   "codigo_obra"
    t.datetime "data_fim"
    t.datetime "data_inicio"
    t.integer  "id_servico"
    t.integer  "id_medicao"
    t.string   "numero_medicao"
    t.decimal  "valor_medido"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["integration_constructions_dae_id"], name: "index_i_c_dae_measurements_on_integration_constructions_dae_id", using: :btree
  end

  create_table "integration_constructions_dae_photos", force: :cascade do |t|
    t.integer  "integration_constructions_dae_id"
    t.string   "codigo_obra"
    t.integer  "id_medicao"
    t.string   "descricao_conta_associada"
    t.string   "legenda"
    t.string   "url_foto"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["integration_constructions_dae_id"], name: "index_i_c_dae_photos_on_integration_constructions_dae_id", using: :btree
  end

  create_table "integration_constructions_daes", force: :cascade do |t|
    t.integer  "id_obra"
    t.string   "codigo_obra"
    t.string   "contratada"
    t.datetime "data_fim_previsto"
    t.datetime "data_inicio"
    t.datetime "data_ordem_servico"
    t.string   "descricao"
    t.integer  "dias_aditivado"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "municipio"
    t.string   "numero_licitacao"
    t.string   "numero_ordem_servico"
    t.string   "numero_sacc"
    t.decimal  "percentual_executado"
    t.integer  "prazo_inicial"
    t.string   "secretaria"
    t.string   "status"
    t.string   "tipo_contrato"
    t.decimal  "valor"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "dae_status"
    t.integer  "organ_id"
    t.index ["codigo_obra"], name: "index_integration_constructions_daes_on_codigo_obra", using: :btree
    t.index ["contratada"], name: "index_integration_constructions_daes_on_contratada", using: :btree
    t.index ["dae_status"], name: "index_integration_constructions_daes_on_dae_status", using: :btree
    t.index ["id_obra"], name: "index_integration_constructions_daes_on_id_obra", using: :btree
    t.index ["municipio"], name: "index_integration_constructions_daes_on_municipio", using: :btree
    t.index ["organ_id"], name: "index_integration_constructions_daes_on_organ_id", using: :btree
    t.index ["secretaria"], name: "index_integration_constructions_daes_on_secretaria", using: :btree
    t.index ["status"], name: "index_integration_constructions_daes_on_status", using: :btree
  end

  create_table "integration_constructions_der_measurements", force: :cascade do |t|
    t.integer  "integration_constructions_der_id"
    t.integer  "id_medicao"
    t.integer  "id_obra"
    t.integer  "id_status"
    t.string   "ano_mes"
    t.date     "ano_mes_date"
    t.string   "numero_contrato_der"
    t.string   "numero_contrato_sac"
    t.integer  "numero_medicao"
    t.string   "rodovia"
    t.string   "status"
    t.string   "status_medicao"
    t.decimal  "valor_medido"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["integration_constructions_der_id"], name: "index_i_c_der_measurements_on_integration_constructions_der_id", using: :btree
  end

  create_table "integration_constructions_ders", force: :cascade do |t|
    t.string   "base"
    t.string   "cerca"
    t.datetime "conclusao"
    t.string   "construtora"
    t.string   "cor_status"
    t.datetime "data_fim_contrato"
    t.datetime "data_fim_previsto"
    t.string   "distrito"
    t.string   "drenagem"
    t.decimal  "extensao"
    t.integer  "id_obra"
    t.string   "numero_contrato_der"
    t.string   "numero_contrato_ext"
    t.string   "numero_contrato_sic"
    t.string   "obra_darte"
    t.integer  "percentual_executado"
    t.string   "programa"
    t.integer  "qtd_empregos"
    t.integer  "qtd_geo_referencias"
    t.string   "revestimento"
    t.string   "rodovia"
    t.string   "servicos"
    t.string   "sinalizacao"
    t.string   "status"
    t.string   "supervisora"
    t.string   "terraplanagem"
    t.string   "trecho"
    t.datetime "ult_atual"
    t.decimal  "valor_aprovado"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "der_status"
    t.datetime "data_inicio_obra"
    t.datetime "data_ordem_servico"
    t.integer  "dias_adicionado"
    t.integer  "dias_suspenso"
    t.string   "municipio"
    t.string   "numero_ordem_servico"
    t.integer  "prazo_inicial"
    t.decimal  "total_aditivo"
    t.decimal  "total_reajuste"
    t.decimal  "valor_atual"
    t.decimal  "valor_original"
    t.decimal  "valor_pi"
    t.string   "latitude"
    t.string   "longitude"
    t.index ["construtora"], name: "index_integration_constructions_ders_on_construtora", using: :btree
    t.index ["der_status"], name: "index_integration_constructions_ders_on_der_status", using: :btree
    t.index ["distrito"], name: "index_integration_constructions_ders_on_distrito", using: :btree
    t.index ["id_obra"], name: "index_integration_constructions_ders_on_id_obra", using: :btree
    t.index ["numero_contrato_der"], name: "index_integration_constructions_ders_on_numero_contrato_der", using: :btree
    t.index ["numero_contrato_sic"], name: "index_integration_constructions_ders_on_numero_contrato_sic", using: :btree
    t.index ["programa"], name: "index_integration_constructions_ders_on_programa", using: :btree
    t.index ["status"], name: "index_integration_constructions_ders_on_status", using: :btree
    t.index ["supervisora"], name: "index_integration_constructions_ders_on_supervisora", using: :btree
  end

  create_table "integration_contracts_additives", force: :cascade do |t|
    t.string   "descricao_observacao"
    t.string   "descricao_tipo_aditivo"
    t.string   "descricao_url"
    t.datetime "data_aditivo"
    t.datetime "data_inicio"
    t.datetime "data_publicacao"
    t.datetime "data_termino"
    t.integer  "flg_tipo_aditivo"
    t.integer  "isn_contrato_aditivo"
    t.integer  "isn_ig"
    t.integer  "isn_sic"
    t.decimal  "valor_acrescimo"
    t.decimal  "valor_reducao"
    t.datetime "data_publicacao_portal"
    t.string   "num_aditivo_siconv"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.date     "data_auditoria"
    t.index ["data_aditivo"], name: "ica_data_aditivo", using: :btree
    t.index ["data_auditoria"], name: "ica_daa", using: :btree
    t.index ["data_inicio"], name: "ica_data_inicio", using: :btree
    t.index ["data_publicacao"], name: "ica_data_publicacao", using: :btree
    t.index ["data_publicacao_portal"], name: "ica_data_publicacao_portal", using: :btree
    t.index ["data_termino"], name: "ica_data_termino", using: :btree
    t.index ["flg_tipo_aditivo"], name: "ica_flg_tipo_aditivo", using: :btree
    t.index ["isn_contrato_aditivo"], name: "ica_isn_contrato_aditivo", using: :btree
    t.index ["isn_ig"], name: "ica_isn_ig", using: :btree
    t.index ["isn_sic"], name: "ica_isn_sic", using: :btree
    t.index ["num_aditivo_siconv"], name: "ica_num_aditivo_siconv", using: :btree
  end

  create_table "integration_contracts_adjustments", force: :cascade do |t|
    t.string   "descricao_observacao"
    t.string   "descricao_tipo_ajuste"
    t.datetime "data_ajuste"
    t.datetime "data_alteracao"
    t.datetime "data_exclusao"
    t.datetime "data_inclusao"
    t.datetime "data_inicio"
    t.datetime "data_termino"
    t.integer  "flg_acrescimo_reducao"
    t.integer  "flg_controle_transmissao"
    t.integer  "flg_receita_despesa"
    t.integer  "flg_tipo_ajuste"
    t.integer  "isn_contrato_ajuste"
    t.integer  "isn_contrato_tipo_ajuste"
    t.integer  "ins_edital"
    t.integer  "isn_sic"
    t.integer  "isn_situacao"
    t.integer  "isn_usuario_alteracao"
    t.integer  "isn_usuario_aprovacao"
    t.integer  "isn_usuario_auditoria"
    t.integer  "isn_usuario_exclusao"
    t.decimal  "valor_ajuste_destino"
    t.decimal  "valor_ajuste_origem"
    t.decimal  "valor_inicio_destino"
    t.decimal  "valor_inicio_origem"
    t.decimal  "valor_termino_origem"
    t.decimal  "valor_termino_destino"
    t.string   "descricao_url"
    t.string   "num_apostilamento_siconv"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.date     "data_auditoria"
    t.index ["data_ajuste"], name: "icadj_data_ajuste", using: :btree
    t.index ["data_alteracao"], name: "icadj_data_alteracao", using: :btree
    t.index ["data_auditoria"], name: "index_integration_contracts_adjustments_on_data_auditoria", using: :btree
    t.index ["data_exclusao"], name: "icadj_data_exclusao", using: :btree
    t.index ["data_inclusao"], name: "icadj_data_inclusao", using: :btree
    t.index ["data_inicio"], name: "icadj_data_inicio", using: :btree
    t.index ["data_termino"], name: "icadj_data_termino", using: :btree
    t.index ["flg_acrescimo_reducao"], name: "icadj_flg_acrescimo_reducao", using: :btree
    t.index ["flg_controle_transmissao"], name: "icadj_flg_controle_transmissao", using: :btree
    t.index ["flg_receita_despesa"], name: "icadj_flg_receita_despesa", using: :btree
    t.index ["flg_tipo_ajuste"], name: "icadj_flg_tipo_ajuste", using: :btree
    t.index ["ins_edital"], name: "icadj_ins_edital", using: :btree
    t.index ["isn_contrato_ajuste"], name: "icadj_isn_contrato_ajuste", using: :btree
    t.index ["isn_contrato_tipo_ajuste"], name: "icadj_isn_contrato_tipo_ajuste", using: :btree
    t.index ["isn_sic"], name: "icadj_isn_sic", using: :btree
    t.index ["isn_situacao"], name: "icadj_isn_situacao", using: :btree
    t.index ["isn_usuario_alteracao"], name: "icadj_isn_usuario_alteracao", using: :btree
    t.index ["isn_usuario_aprovacao"], name: "icadj_isn_usuario_aprovacao", using: :btree
    t.index ["isn_usuario_auditoria"], name: "icadj_isn_usuario_auditoria", using: :btree
    t.index ["isn_usuario_exclusao"], name: "icadj_isn_usuario_exclusao", using: :btree
    t.index ["num_apostilamento_siconv"], name: "icadj_num_apostilamento_siconv", using: :btree
  end

  create_table "integration_contracts_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "user"
    t.string   "password"
    t.string   "contract_operation"
    t.string   "contract_response_path"
    t.string   "contract_parameters"
    t.string   "additive_operation"
    t.string   "additive_response_path"
    t.string   "additive_parameters"
    t.string   "adjustment_operation"
    t.string   "adjustment_response_path"
    t.string   "adjustment_parameters"
    t.string   "financial_operation"
    t.string   "financial_response_path"
    t.string   "financial_parameters"
    t.string   "infringement_operation"
    t.string   "infringement_response_path"
    t.string   "infringement_parameters"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "headers_soap_action"
    t.date     "start_at"
    t.date     "end_at"
  end

  create_table "integration_contracts_contracts", force: :cascade do |t|
    t.string   "cod_concedente"
    t.string   "cod_financiador"
    t.string   "cod_gestora"
    t.string   "cod_orgao"
    t.string   "cod_secretaria"
    t.string   "decricao_modalidade"
    t.string   "descricao_objeto"
    t.string   "descricao_tipo"
    t.string   "descricao_url"
    t.datetime "data_assinatura"
    t.datetime "data_processamento"
    t.datetime "data_termino"
    t.integer  "flg_tipo"
    t.integer  "isn_parte_destino"
    t.integer  "isn_sic"
    t.string   "num_spu"
    t.decimal  "valor_contrato"
    t.integer  "isn_modalidade"
    t.integer  "isn_entidade"
    t.string   "tipo_objeto"
    t.string   "num_spu_licitacao"
    t.string   "descricao_justificativa"
    t.decimal  "valor_can_rstpg"
    t.datetime "data_publicacao_portal"
    t.string   "descricao_url_pltrb"
    t.string   "descricao_url_ddisp"
    t.string   "descricao_url_inexg"
    t.string   "cod_plano_trabalho"
    t.string   "num_certidao"
    t.string   "descriaco_edital"
    t.string   "cpf_cnpj_financiador"
    t.string   "num_contrato"
    t.decimal  "valor_original_concedente"
    t.decimal  "valor_original_contrapartida"
    t.decimal  "valor_atualizado_concedente"
    t.decimal  "valor_atualizado_contrapartida"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "plain_num_contrato"
    t.decimal  "calculated_valor_aditivo"
    t.decimal  "calculated_valor_ajuste"
    t.decimal  "calculated_valor_empenhado"
    t.decimal  "calculated_valor_pago"
    t.integer  "contract_type"
    t.integer  "infringement_status"
    t.string   "cod_financiador_including_zeroes"
    t.string   "accountability_status"
    t.string   "plain_cpf_cnpj_financiador"
    t.string   "descricao_situacao"
    t.datetime "data_publicacao_doe"
    t.text     "descricao_nome_credor"
    t.string   "isn_parte_origem"
    t.date     "data_auditoria"
    t.datetime "data_termino_original"
    t.datetime "data_inicio"
    t.datetime "data_rescisao"
    t.boolean  "confidential"
    t.index ["accountability_status"], name: "icc_accountability_status", using: :btree
    t.index ["cod_concedente"], name: "icc_cod_concedente", using: :btree
    t.index ["cod_financiador"], name: "icc_cod_financiador", using: :btree
    t.index ["cod_financiador_including_zeroes"], name: "icc_cod_financiador_including_zeroes", using: :btree
    t.index ["cod_gestora"], name: "icc_cod_gestora", using: :btree
    t.index ["cod_orgao"], name: "icc_cod_orgao", using: :btree
    t.index ["cod_secretaria"], name: "icc_cod_secretaria", using: :btree
    t.index ["contract_type"], name: "index_integration_contracts_contracts_on_contract_type", using: :btree
    t.index ["data_assinatura"], name: "icc_data_assinatura", using: :btree
    t.index ["data_auditoria"], name: "index_integration_contracts_contracts_on_data_auditoria", using: :btree
    t.index ["data_inicio"], name: "icc_data_inicio", using: :btree
    t.index ["data_processamento"], name: "icc_data_processamento", using: :btree
    t.index ["data_rescisao"], name: "icc_data_rescisao", using: :btree
    t.index ["data_termino"], name: "icc_data_termino", using: :btree
    t.index ["data_termino_original"], name: "icc_data_termino_original", using: :btree
    t.index ["decricao_modalidade"], name: "icc_decricao_modalidade", using: :btree
    t.index ["descricao_nome_credor"], name: "index_integration_contracts_contracts_on_descricao_nome_credor", using: :btree
    t.index ["descricao_situacao"], name: "icc_descricao_situacao", using: :btree
    t.index ["flg_tipo"], name: "icc_flg_tipo", using: :btree
    t.index ["infringement_status"], name: "index_integration_contracts_contracts_on_infringement_status", using: :btree
    t.index ["isn_modalidade"], name: "icc_isn_modalidade", using: :btree
    t.index ["isn_parte_origem"], name: "icc_isn_parte_origem", using: :btree
    t.index ["isn_sic"], name: "index_integration_contracts_contracts_on_isn_sic", using: :btree
    t.index ["num_contrato"], name: "icc_num_contrato", using: :btree
    t.index ["plain_cpf_cnpj_financiador"], name: "icc_plain_cpf_cnpj_financiador", using: :btree
    t.index ["plain_num_contrato"], name: "icc_plain_num_contrato", using: :btree
  end

  create_table "integration_contracts_financials", force: :cascade do |t|
    t.string   "ano_documento"
    t.integer  "cod_entidade"
    t.integer  "cod_fonte"
    t.integer  "cod_gestor"
    t.string   "descricao_entidade"
    t.string   "descricao_objeto"
    t.datetime "data_documento"
    t.datetime "data_pagamento"
    t.datetime "data_processamento"
    t.integer  "flg_sic"
    t.integer  "isn_sic"
    t.string   "num_pagamento"
    t.string   "num_documento"
    t.decimal  "valor_documento"
    t.decimal  "valor_pagamento"
    t.string   "cod_credor"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.date     "data_auditoria"
    t.index ["ano_documento"], name: "icfin_ano_documento", using: :btree
    t.index ["cod_credor"], name: "icfin_cod_credor", using: :btree
    t.index ["cod_entidade"], name: "icfin_cod_entidade", using: :btree
    t.index ["cod_fonte"], name: "icfin_cod_fonte", using: :btree
    t.index ["cod_gestor"], name: "icfin_cod_gestor", using: :btree
    t.index ["data_auditoria"], name: "index_integration_contracts_financials_on_data_auditoria", using: :btree
    t.index ["data_documento"], name: "icfin_data_documento", using: :btree
    t.index ["data_pagamento"], name: "icfin_data_pagamento", using: :btree
    t.index ["data_processamento"], name: "icfin_data_processamento", using: :btree
    t.index ["flg_sic"], name: "icfin_flg_sic", using: :btree
    t.index ["isn_sic"], name: "icfin_isn_sic", using: :btree
    t.index ["num_documento"], name: "icfin_num_documento", using: :btree
    t.index ["num_pagamento"], name: "icfin_num_pagamento", using: :btree
  end

  create_table "integration_contracts_infringements", force: :cascade do |t|
    t.string   "cod_financiador"
    t.string   "cod_gestora"
    t.string   "descricao_entidade"
    t.string   "descricao_financiador"
    t.string   "descricao_motivo_inadimplencia"
    t.datetime "data_lancamento"
    t.datetime "data_processamento"
    t.datetime "data_termino_atual"
    t.datetime "data_ultima_pcontas"
    t.datetime "data_ultima_pagto"
    t.integer  "isn_sic"
    t.integer  "qtd_pagtos"
    t.decimal  "valor_atualizado_total"
    t.decimal  "valor_inadimplencia"
    t.decimal  "valor_liberacoes"
    t.decimal  "valor_pcontas_acomprovar"
    t.decimal  "valor_pcontas_apresentada"
    t.decimal  "valor_pcontas_aprovada"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["cod_financiador"], name: "icinfrin_cod_financiador", using: :btree
    t.index ["cod_gestora"], name: "icinfrin_cod_gestora", using: :btree
    t.index ["data_lancamento"], name: "icinfrin_data_lancamento", using: :btree
    t.index ["data_processamento"], name: "icinfrin_data_processamento", using: :btree
    t.index ["data_termino_atual"], name: "icinfrin_data_termino_atual", using: :btree
    t.index ["data_ultima_pagto"], name: "icinfrin_data_ultima_pagto", using: :btree
    t.index ["data_ultima_pcontas"], name: "icinfrin_data_ultima_pcontas", using: :btree
    t.index ["isn_sic"], name: "icinfrin_isn_sic", using: :btree
  end

  create_table "integration_contracts_situations", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "integration_eparcerias_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.string   "headers_soap_action"
    t.integer  "import_type"
    t.string   "transfer_bank_order_operation"
    t.string   "transfer_bank_order_response_path"
    t.string   "work_plan_attachment_operation"
    t.string   "work_plan_attachment_response_path"
    t.string   "accountability_operation"
    t.string   "accountability_response_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integration_eparcerias_transfer_bank_orders", force: :cascade do |t|
    t.integer  "isn_sic"
    t.string   "numero_ordem_bancaria"
    t.string   "tipo_ordem_bancaria"
    t.string   "nome_benceficiario"
    t.datetime "data_pagamento"
    t.decimal  "valor_ordem_bancaria",  precision: 12, scale: 2
    t.index ["isn_sic"], name: "ictbo_isn_sic", using: :btree
    t.index ["numero_ordem_bancaria"], name: "ictbo_numero_ordem_bancaria", using: :btree
    t.index ["tipo_ordem_bancaria"], name: "ictbo_tipo_ordem_bancaria", using: :btree
  end

  create_table "integration_eparcerias_work_plan_attachments", force: :cascade do |t|
    t.string  "file_name"
    t.string  "file_type"
    t.integer "file_size"
    t.text    "description"
    t.integer "isn_sic"
    t.index ["isn_sic"], name: "iewpa_isn_sic", using: :btree
  end

  create_table "integration_expenses_budget_balances", force: :cascade do |t|
    t.string   "data_atual"
    t.string   "ano_mes_competencia"
    t.string   "cod_unid_gestora"
    t.string   "cod_unid_orcam"
    t.string   "cod_funcao"
    t.string   "cod_subfuncao"
    t.string   "cod_programa"
    t.string   "cod_acao"
    t.string   "cod_localizacao_gasto"
    t.string   "cod_natureza_desp"
    t.string   "cod_fonte"
    t.string   "id_uso"
    t.string   "cod_grupo_desp"
    t.string   "cod_tp_orcam"
    t.string   "cod_esfera_orcam"
    t.string   "cod_grupo_fin"
    t.string   "classif_orcam_reduz"
    t.string   "classif_orcam_completa"
    t.decimal  "valor_inicial"
    t.decimal  "valor_suplementado"
    t.decimal  "valor_anulado"
    t.decimal  "valor_transferido_recebido"
    t.decimal  "valor_transferido_concedido"
    t.decimal  "valor_contido"
    t.decimal  "valor_contido_anulado"
    t.decimal  "valor_descentralizado"
    t.decimal  "valor_descentralizado_anulado"
    t.decimal  "valor_empenhado"
    t.decimal  "valor_empenhado_anulado"
    t.decimal  "valor_liquidado"
    t.decimal  "valor_liquidado_anulado"
    t.decimal  "valor_liquidado_retido"
    t.decimal  "valor_liquidado_retido_anulado"
    t.decimal  "valor_pago"
    t.decimal  "valor_pago_anulado"
    t.decimal  "calculated_valor_orcamento_inicial"
    t.decimal  "calculated_valor_orcamento_atualizado"
    t.decimal  "calculated_valor_empenhado"
    t.decimal  "calculated_valor_liquidado"
    t.decimal  "calculated_valor_pago"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "year"
    t.integer  "month"
    t.integer  "integration_supports_organ_id"
    t.integer  "integration_supports_secretary_id"
    t.integer  "integration_supports_government_program_id"
    t.string   "cod_categoria_economica"
    t.string   "cod_modalidade_aplicacao"
    t.string   "cod_elemento_despesa"
    t.index ["ano_mes_competencia"], name: "iebb_ano_mes_competencia", using: :btree
    t.index ["classif_orcam_completa"], name: "iebb_classif_orcam_completa", using: :btree
    t.index ["cod_acao"], name: "iebb_cod_acao", using: :btree
    t.index ["cod_categoria_economica"], name: "iebb_cod_categoria_economica", using: :btree
    t.index ["cod_elemento_despesa"], name: "iebb_cod_elemento_despesa", using: :btree
    t.index ["cod_esfera_orcam"], name: "iebb_cod_esfera_orcam", using: :btree
    t.index ["cod_fonte"], name: "iebb_cod_fonte", using: :btree
    t.index ["cod_funcao"], name: "iebb_cod_funcao", using: :btree
    t.index ["cod_grupo_desp"], name: "iebb_cod_grupo_desp", using: :btree
    t.index ["cod_grupo_fin"], name: "iebb_cod_grupo_fin", using: :btree
    t.index ["cod_localizacao_gasto"], name: "iebb_cod_localizacao_gasto", using: :btree
    t.index ["cod_modalidade_aplicacao"], name: "iebb_cod_modalidade_aplicacao", using: :btree
    t.index ["cod_natureza_desp"], name: "iebb_cod_natureza_desp", using: :btree
    t.index ["cod_programa"], name: "iebb_cod_programa", using: :btree
    t.index ["cod_subfuncao"], name: "iebb_cod_subfuncao", using: :btree
    t.index ["cod_tp_orcam"], name: "iebb_cod_tp_orcam", using: :btree
    t.index ["cod_unid_gestora"], name: "iebb_cod_unid_gestora", using: :btree
    t.index ["cod_unid_orcam"], name: "iebb_cod_unid_orcam", using: :btree
    t.index ["id_uso"], name: "iebb_id_uso", using: :btree
    t.index ["integration_supports_government_program_id"], name: "iebb_government_program_id", using: :btree
    t.index ["integration_supports_organ_id"], name: "iebb_integration_supports_organ_id", using: :btree
    t.index ["integration_supports_secretary_id"], name: "iebb_integration_supports_secretary_id", using: :btree
    t.index ["month"], name: "iebb_month", using: :btree
    t.index ["year"], name: "iebb_year", using: :btree
  end

  create_table "integration_expenses_configurations", force: :cascade do |t|
    t.string   "npf_wsdl"
    t.string   "npf_headers_soap_action"
    t.string   "npf_operation"
    t.string   "npf_response_path"
    t.string   "npf_user"
    t.string   "npf_password"
    t.string   "ned_wsdl"
    t.string   "ned_headers_soap_action"
    t.string   "ned_operation"
    t.string   "ned_response_path"
    t.string   "ned_user"
    t.string   "ned_password"
    t.string   "nld_wsdl"
    t.string   "nld_headers_soap_action"
    t.string   "nld_operation"
    t.string   "nld_response_path"
    t.string   "nld_user"
    t.string   "nld_password"
    t.string   "npd_wsdl"
    t.string   "npd_headers_soap_action"
    t.string   "npd_operation"
    t.string   "npd_response_path"
    t.string   "npd_user"
    t.string   "npd_password"
    t.datetime "last_importation"
    t.text     "log"
    t.integer  "status"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.date     "started_at"
    t.date     "finished_at"
    t.string   "budget_balance_wsdl"
    t.string   "budget_balance_headers_soap_action"
    t.string   "budget_balance_operation"
    t.string   "budget_balance_response_path"
    t.string   "budget_balance_user"
    t.string   "budget_balance_password"
  end

  create_table "integration_expenses_ned_disbursement_forecasts", force: :cascade do |t|
    t.string   "data"
    t.decimal  "valor"
    t.integer  "integration_expenses_ned_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["integration_expenses_ned_id"], name: "index_expenses_ned_disbursement_forecasts_on_ned_id", using: :btree
  end

  create_table "integration_expenses_ned_items", force: :cascade do |t|
    t.integer  "sequencial"
    t.string   "especificacao"
    t.string   "unidade"
    t.decimal  "quantidade"
    t.decimal  "valor_unitario"
    t.integer  "integration_expenses_ned_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["integration_expenses_ned_id"], name: "index_expenses_ned_items_on_ned_id", using: :btree
  end

  create_table "integration_expenses_ned_planning_items", force: :cascade do |t|
    t.integer  "isn_item_parcela"
    t.decimal  "valor"
    t.integer  "integration_expenses_ned_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["integration_expenses_ned_id"], name: "index_expenses_ned_planning_items_on_ned_id", using: :btree
  end

  create_table "integration_expenses_neds", force: :cascade do |t|
    t.integer  "exercicio"
    t.string   "unidade_gestora"
    t.string   "unidade_executora"
    t.string   "numero"
    t.string   "numero_ned_ordinaria"
    t.string   "natureza"
    t.string   "efeito"
    t.string   "data_emissao"
    t.decimal  "valor"
    t.decimal  "valor_pago"
    t.integer  "classificacao_orcamentaria_reduzido"
    t.string   "classificacao_orcamentaria_completo"
    t.string   "item_despesa"
    t.string   "cpf_ordenador_despesa"
    t.string   "credor"
    t.string   "cpf_cnpj_credor"
    t.string   "razao_social_credor"
    t.string   "numero_npf_ordinario"
    t.string   "projeto"
    t.string   "numero_parcela"
    t.integer  "isn_parcela"
    t.string   "numero_contrato"
    t.string   "numero_convenio"
    t.string   "modalidade_sem_licitacao"
    t.string   "codigo_dispositivo_legal"
    t.string   "modalidade_licitacao"
    t.integer  "tipo_proposta"
    t.integer  "numero_proposta"
    t.integer  "numero_proposta_origem"
    t.string   "numero_processo_protocolo_original"
    t.string   "especificacao_geral"
    t.string   "data_atual"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.date     "date_of_issue"
    t.decimal  "calculated_valor_final"
    t.decimal  "calculated_valor_pago_final"
    t.decimal  "calculated_valor_suplementado"
    t.decimal  "calculated_valor_pago_suplementado"
    t.decimal  "calculated_valor_anulado"
    t.decimal  "calculated_valor_pago_anulado"
    t.string   "classificacao_unidade_orcamentaria"
    t.string   "classificacao_funcao"
    t.string   "classificacao_subfuncao"
    t.string   "classificacao_programa_governo"
    t.string   "classificacao_acao_governamental"
    t.string   "classificacao_regiao_administrativa"
    t.string   "classificacao_natureza_despesa"
    t.string   "classificacao_cod_destinacao"
    t.string   "classificacao_fonte_recursos"
    t.string   "classificacao_subfonte"
    t.string   "classificacao_id_uso"
    t.string   "classificacao_tipo_despesa"
    t.integer  "transfer_type"
    t.string   "classificacao_elemento_despesa"
    t.decimal  "calculated_valor_liquidado_exercicio"
    t.decimal  "calculated_valor_liquidado_apos_exercicio"
    t.decimal  "calculated_valor_pago_exercicio"
    t.decimal  "calculated_valor_pago_apos_exercicio"
    t.string   "composed_key"
    t.index ["classificacao_acao_governamental"], name: "iens_classificacao_acao_governamental", using: :btree
    t.index ["classificacao_cod_destinacao"], name: "iens_classificacao_cod_destinacao", using: :btree
    t.index ["classificacao_elemento_despesa"], name: "ien_c_elemento_despesa", using: :btree
    t.index ["classificacao_fonte_recursos"], name: "iens_classificacao_fonte_recursos", using: :btree
    t.index ["classificacao_funcao"], name: "iens_classificacao_funcao", using: :btree
    t.index ["classificacao_id_uso"], name: "iens_classificacao_id_uso", using: :btree
    t.index ["classificacao_natureza_despesa"], name: "iens_classificacao_natureza_despesa", using: :btree
    t.index ["classificacao_programa_governo"], name: "iens_classificacao_programa_governo", using: :btree
    t.index ["classificacao_regiao_administrativa"], name: "iens_classificacao_regiao_administrativa", using: :btree
    t.index ["classificacao_subfonte"], name: "iens_classificacao_subfonte", using: :btree
    t.index ["classificacao_subfuncao"], name: "iens_classificacao_subfuncao", using: :btree
    t.index ["classificacao_tipo_despesa"], name: "iens_classificacao_tipo_despesa", using: :btree
    t.index ["classificacao_unidade_orcamentaria"], name: "iens_classificacao_unidade_orcamentaria", using: :btree
    t.index ["composed_key"], name: "ien_composed_key", using: :btree
    t.index ["credor"], name: "ieneds_credor", using: :btree
    t.index ["date_of_issue"], name: "iened_date_of_issue", using: :btree
    t.index ["exercicio", "unidade_gestora", "numero"], name: "index_exercicio_unidade_gestora_numero_on_neds", unique: true, using: :btree
    t.index ["exercicio"], name: "ieneds_exercicio", using: :btree
    t.index ["natureza"], name: "ieneds_natureza", using: :btree
    t.index ["numero"], name: "ieneds_numero", using: :btree
    t.index ["numero_contrato"], name: "ieneds_numero_contrato", using: :btree
    t.index ["numero_convenio"], name: "ieneds_numero_convenio", using: :btree
    t.index ["numero_ned_ordinaria"], name: "ieneds_numero_ned_ordinaria", using: :btree
    t.index ["numero_npf_ordinario"], name: "ieneds_numero_npf_ordinario", using: :btree
    t.index ["projeto"], name: "ieneds_projeto", using: :btree
    t.index ["transfer_type"], name: "ien_transfer_type", using: :btree
    t.index ["unidade_executora"], name: "ieneds_unidade_executora", using: :btree
    t.index ["unidade_gestora"], name: "ieneds_unidade_gestora", using: :btree
  end

  create_table "integration_expenses_nld_item_payment_plannings", force: :cascade do |t|
    t.integer  "codigo_isn"
    t.decimal  "valor_liquidado"
    t.integer  "integration_expenses_nld_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["integration_expenses_nld_id"], name: "index_expenses_nld_payment_planning_on_nld_id", using: :btree
  end

  create_table "integration_expenses_nld_item_payment_retentions", force: :cascade do |t|
    t.string   "codigo_retencao"
    t.string   "credor"
    t.decimal  "valor"
    t.integer  "integration_expenses_nld_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["integration_expenses_nld_id"], name: "index_expenses_nld_payment_retentions_on_nld_id", using: :btree
  end

  create_table "integration_expenses_nlds", force: :cascade do |t|
    t.integer  "exercicio"
    t.string   "unidade_gestora"
    t.string   "unidade_executora"
    t.string   "numero"
    t.string   "numero_nld_ordinaria"
    t.string   "natureza"
    t.string   "tipo_de_documento_da_despesa"
    t.string   "numero_do_documento_da_despesa"
    t.string   "data_do_documento_da_despesa"
    t.string   "efeito"
    t.string   "processo_administrativo_despesa"
    t.string   "data_emissao"
    t.decimal  "valor"
    t.decimal  "valor_retido"
    t.string   "cpf_ordenador_despesa"
    t.string   "credor"
    t.string   "numero_npf_ordinaria"
    t.string   "numero_nota_empenho_despesa"
    t.string   "tipo_despesa_extra_orcamentaria"
    t.string   "especificacao_restituicao"
    t.string   "exercicio_restos_a_pagar"
    t.string   "data_atual"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.date     "date_of_issue"
    t.decimal  "calculated_valor_final"
    t.decimal  "calculated_valor_anulado"
    t.string   "ned_composed_key"
    t.string   "composed_key"
    t.index ["composed_key"], name: "ienlds_composed_key", using: :btree
    t.index ["credor"], name: "ienlds_credor", using: :btree
    t.index ["date_of_issue"], name: "ienld_date_of_issue", using: :btree
    t.index ["exercicio", "unidade_gestora", "numero"], name: "index_exercicio_unidade_gestora_numero_on_nlds", unique: true, using: :btree
    t.index ["exercicio"], name: "ienlds_exercicio", using: :btree
    t.index ["natureza"], name: "ienlds_natureza", using: :btree
    t.index ["ned_composed_key"], name: "ien_ned_composed_key", using: :btree
    t.index ["numero"], name: "ienlds_numero", using: :btree
    t.index ["numero_do_documento_da_despesa"], name: "ienlds_numero_do_documento_da_despesa", using: :btree
    t.index ["numero_nld_ordinaria"], name: "ienlds_numero_nld_ordinaria", using: :btree
    t.index ["numero_nota_empenho_despesa"], name: "ienlds_numero_nota_empenho_despesa", using: :btree
    t.index ["numero_npf_ordinaria"], name: "ienlds_numero_npf_ordinaria", using: :btree
    t.index ["unidade_executora"], name: "ienlds_unidade_executora", using: :btree
    t.index ["unidade_gestora"], name: "ienlds_unidade_gestora", using: :btree
  end

  create_table "integration_expenses_npds", force: :cascade do |t|
    t.integer  "exercicio"
    t.string   "unidade_gestora"
    t.string   "unidade_executora"
    t.string   "numero"
    t.string   "numero_npd_ordinaria"
    t.string   "codigo_localidade_npd_ordinaria"
    t.string   "codigo_retencao"
    t.string   "natureza"
    t.string   "justificativa"
    t.string   "efeito"
    t.string   "numero_processo_administrativo_despesa"
    t.string   "data_emissao"
    t.string   "credor"
    t.string   "documento_credor"
    t.decimal  "valor"
    t.string   "numero_nld_ordinaria"
    t.string   "codigo_natureza_receita"
    t.string   "servico_bancario"
    t.string   "banco_origem"
    t.string   "agencia_origem"
    t.string   "digito_agencia_origem"
    t.string   "conta_origem"
    t.string   "digito_conta_origem"
    t.string   "banco_pagamento"
    t.string   "codigo_localidade"
    t.string   "banco_beneficiario"
    t.string   "agencia_beneficiario"
    t.string   "digito_agencia_beneficiario"
    t.string   "conta_beneficiario"
    t.string   "digito_conta_beneficiario"
    t.string   "status_movimento_bancario"
    t.string   "data_retorno_remessa_bancaria"
    t.string   "processo_judicial"
    t.string   "data_atual"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.date     "date_of_issue"
    t.string   "nld_composed_key"
    t.boolean  "daily"
    t.decimal  "calculated_valor_final"
    t.index ["credor"], name: "ienpds_credor", using: :btree
    t.index ["daily"], name: "ienpd_daily", using: :btree
    t.index ["date_of_issue"], name: "ienpd_date_of_issue", using: :btree
    t.index ["exercicio", "unidade_gestora", "numero"], name: "index_exercicio_unidade_gestora_numero_on_npds", unique: true, using: :btree
    t.index ["exercicio"], name: "ienpds_exercicio", using: :btree
    t.index ["natureza"], name: "ienpds_natureza", using: :btree
    t.index ["nld_composed_key"], name: "ien_nld_composed_key", using: :btree
    t.index ["numero"], name: "ienpds_numero", using: :btree
    t.index ["numero_nld_ordinaria"], name: "ienpds_numero_npf_ordinaria", using: :btree
    t.index ["numero_npd_ordinaria"], name: "ienpds_numero_npd_ordinaria", using: :btree
    t.index ["servico_bancario"], name: "ienpds_servico_bancario", using: :btree
    t.index ["unidade_executora"], name: "ienpds_unidade_executora", using: :btree
    t.index ["unidade_gestora"], name: "ienpds_unidade_gestora", using: :btree
  end

  create_table "integration_expenses_npfs", force: :cascade do |t|
    t.integer  "exercicio"
    t.string   "unidade_gestora"
    t.string   "unidade_executora"
    t.string   "numero"
    t.string   "numero_npf_ord"
    t.string   "natureza"
    t.string   "tipo_proc_adm_desp"
    t.string   "efeito"
    t.string   "data_emissao"
    t.string   "grupo_fin"
    t.string   "fonte_rec"
    t.decimal  "valor"
    t.string   "credor"
    t.string   "codigo_projeto"
    t.string   "numero_parcela"
    t.string   "isn_parcela"
    t.string   "numeroconvenio"
    t.string   "data_atual"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "date_of_issue"
    t.decimal  "calculated_valor_final"
    t.decimal  "calculated_valor_suplementado"
    t.decimal  "calculated_valor_anulado"
    t.index ["credor"], name: "ienpfs_credor", using: :btree
    t.index ["date_of_issue"], name: "ienpf_date_of_issue", using: :btree
    t.index ["exercicio", "unidade_gestora", "numero"], name: "index_exercicio_unidade_gestora_numero_on_npfs", unique: true, using: :btree
    t.index ["exercicio"], name: "ienpfs_exercicio", using: :btree
    t.index ["natureza"], name: "ienpfs_natureza", using: :btree
    t.index ["numero"], name: "ienpfs_numero", using: :btree
    t.index ["numero_npf_ord"], name: "ienpfs_numero_npf_ord", using: :btree
    t.index ["unidade_executora"], name: "ienpfs_unidade_executora", using: :btree
    t.index ["unidade_gestora"], name: "ienpfs_unidade_gestora", using: :btree
  end

  create_table "integration_macroregions_configurations", force: :cascade do |t|
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.integer  "power"
    t.integer  "year"
    t.string   "wsdl"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_macroregions_macroregion_investiments", force: :cascade do |t|
    t.string   "ano_exercicio"
    t.string   "codigo_poder"
    t.string   "descricao_poder"
    t.string   "codigo_regiao"
    t.string   "descricao_regiao"
    t.decimal  "valor_lei"
    t.decimal  "valor_lei_creditos"
    t.decimal  "valor_empenhado"
    t.decimal  "valor_pago"
    t.decimal  "perc_empenho"
    t.decimal  "perc_pago"
    t.integer  "power_id"
    t.integer  "region_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.decimal  "perc_pago_calculated"
    t.index ["ano_exercicio", "codigo_poder", "codigo_regiao"], name: "immi_index_primary", unique: true, using: :btree
    t.index ["power_id"], name: "index_integration_mr_mi_on_powers_id", using: :btree
    t.index ["region_id"], name: "index_integration_mr_mi_on_regions_id", using: :btree
  end

  create_table "integration_macroregions_powers", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "integration_macroregions_regions", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "integration_outsourcing_categories", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["description"], name: "index_integration_outsourcing_categories_on_description", using: :btree
  end

  create_table "integration_outsourcing_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "entity_operation"
    t.string   "entity_response_path"
    t.string   "monthly_cost_operation"
    t.string   "monthly_cost_response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.string   "month"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "consolidation_operation"
    t.string   "consolidation_response_path"
  end

  create_table "integration_outsourcing_consolidations", force: :cascade do |t|
    t.string   "mes"
    t.integer  "qde_terc_alocados"
    t.decimal  "vlr_custo"
    t.decimal  "vlr_remuneracao"
    t.decimal  "vlr_encargos_taxas"
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["mes"], name: "index_integration_outsourcing_consolidations_on_mes", using: :btree
    t.index ["month"], name: "index_integration_outsourcing_consolidations_on_month", using: :btree
    t.index ["year", "month"], name: "index_integration_outsourcing_consolidations_on_year_and_month", using: :btree
    t.index ["year"], name: "index_integration_outsourcing_consolidations_on_year", using: :btree
  end

  create_table "integration_outsourcing_entities", force: :cascade do |t|
    t.integer  "isn_entidade"
    t.string   "dsc_sigla"
    t.string   "dsc_entidade"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["isn_entidade"], name: "index_integration_outsourcing_entities_on_isn_entidade", using: :btree
  end

  create_table "integration_outsourcing_monthly_costs", force: :cascade do |t|
    t.string   "numerocontrato"
    t.string   "competencia"
    t.string   "nome"
    t.string   "cpf"
    t.string   "orgao"
    t.string   "categoria"
    t.string   "data_inicio"
    t.string   "data_termino"
    t.string   "tipo_servico"
    t.string   "situacao"
    t.integer  "dias_trabalhados"
    t.integer  "qtd_hora_extra"
    t.decimal  "vlr_hora_extra"
    t.integer  "qtd_diarias"
    t.decimal  "vlr_diarias"
    t.decimal  "vlr_vale_transporte"
    t.decimal  "vlr_vale_refeicao"
    t.decimal  "vlr_salario_base"
    t.decimal  "vlr_custo_total"
    t.string   "month_import"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "isn_entidade"
    t.decimal  "vlr_adicional"
    t.decimal  "vlr_adicional_noturno"
    t.decimal  "vlr_reserva_tecnica"
    t.decimal  "vlr_encargos"
    t.decimal  "vlr_taxa"
    t.decimal  "vlr_cesta_basica"
    t.decimal  "vlr_farda"
    t.decimal  "vlr_municao"
    t.decimal  "vlr_seguro_vida"
    t.decimal  "vlr_supervisao"
    t.decimal  "vlr_insalubridade"
    t.decimal  "vlr_periculosidade"
    t.decimal  "vlr_equipamento"
    t.decimal  "vlr_tributos"
    t.decimal  "vlr_total_montante"
    t.decimal  "vlr_dsr"
    t.decimal  "vlr_extra_encargos"
    t.decimal  "vlr_extra_taxa"
    t.decimal  "vlr_extra_tributos"
    t.decimal  "vlr_total_extra"
    t.decimal  "vlr_passagem"
    t.decimal  "vlr_viagem"
    t.decimal  "vlr_viagem_taxa"
    t.decimal  "vlr_viagem_tributos"
    t.decimal  "vlr_total_viagem"
    t.decimal  "vlr_plano_saude"
    t.decimal  "vlr_outros"
    t.decimal  "remuneracao"
    t.index ["categoria"], name: "index_integration_outsourcing_monthly_costs_on_categoria", using: :btree
    t.index ["competencia"], name: "index_integration_outsourcing_monthly_costs_on_competencia", using: :btree
    t.index ["isn_entidade"], name: "index_integration_outsourcing_monthly_costs_on_isn_entidade", using: :btree
    t.index ["month_import"], name: "index_integration_outsourcing_monthly_costs_on_month_import", using: :btree
    t.index ["nome"], name: "index_integration_outsourcing_monthly_costs_on_nome", using: :btree
    t.index ["orgao"], name: "index_integration_outsourcing_monthly_costs_on_orgao", using: :btree
    t.index ["updated_at"], name: "index_integration_outsourcing_monthly_costs_on_updated_at", using: :btree
  end

  create_table "integration_ppa_source_axis_theme_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_ppa_source_axis_theme_objective_strategies", force: :cascade do |t|
    t.string  "ppa_ano_inicio"
    t.string  "ppa_ano_fim"
    t.string  "eixo_cod"
    t.text    "eixo_descricao"
    t.string  "regiao_cod"
    t.string  "regiao_descricao"
    t.string  "tema_cod"
    t.text    "tema_descricao"
    t.string  "objetivo_cod"
    t.text    "objetivo_descricao"
    t.string  "estrategia_cod"
    t.text    "estrategia_descricao"
    t.integer "eixo_isn"
    t.integer "tema_isn"
    t.text    "tema_descricao_detalhada"
    t.integer "regiao_isn"
    t.integer "estrategia_isn"
    t.integer "objetivo_isn"
    t.index ["eixo_isn"], name: "int_ppa_sourc_axis_theme_object_strat_on_eixo_isn", using: :btree
    t.index ["estrategia_isn"], name: "int_ppa_sourc_axis_theme_object_strat_on_estrategia_isn", using: :btree
    t.index ["objetivo_isn"], name: "int_ppa_sourc_axis_theme_object_strat_on_objetivo_isn", using: :btree
    t.index ["regiao_isn"], name: "int_ppa_sourc_axis_theme_object_strat_on_regiao_isn", using: :btree
    t.index ["tema_isn"], name: "int_ppa_sourc_axis_theme_object_strat_on_tema_isn", using: :btree
  end

  create_table "integration_ppa_source_axis_theme_objective_strategy_configurat", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "year"
  end

  create_table "integration_ppa_source_guideline_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.integer  "year"
    t.string   "region"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_ppa_source_region_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_purchases_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.string   "headers_soap_action"
    t.string   "month"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_purchases_purchases", force: :cascade do |t|
    t.string   "numero_publicacao"
    t.string   "numero_viproc"
    t.string   "num_termo_participacao"
    t.string   "cnpj"
    t.string   "nome_resp_compra"
    t.string   "uf_resp_compra"
    t.string   "macro_regiao_org"
    t.string   "micro_regiao_org"
    t.string   "municipio_resp_compra"
    t.string   "cpf_cnpj_fornecedor"
    t.string   "nome_fornecedor"
    t.string   "tipo_fornecedor"
    t.string   "uf_fornecedor"
    t.string   "macro_regiao_fornecedor"
    t.string   "micro_regiao_fornecedor"
    t.string   "municipio_fornecedor"
    t.string   "tipo_material_servico"
    t.string   "nome_grupo"
    t.string   "codigo_item"
    t.string   "descricao_item"
    t.string   "unidade_fornecimento"
    t.string   "marca"
    t.string   "natureza_aquisicao"
    t.string   "tipo_aquisicao"
    t.string   "sistematica_aquisicao"
    t.string   "forma_aquisicao"
    t.boolean  "tratamento_diferenciado"
    t.datetime "data_publicacao"
    t.decimal  "quantidade_estimada"
    t.decimal  "valor_unitario"
    t.datetime "data_finalizada"
    t.decimal  "valor_total_melhor_lance"
    t.decimal  "valor_estimado"
    t.decimal  "valor_total_estimado"
    t.boolean  "aquisicao_contrato"
    t.string   "prazo_entrega"
    t.string   "prazo_pagamento"
    t.string   "exige_amostras"
    t.datetime "data_carga"
    t.string   "ano"
    t.string   "mes"
    t.string   "ano_mes"
    t.string   "codigo_classe_material"
    t.string   "nome_classe_material"
    t.string   "registro_preco"
    t.string   "unid_compra_regiao_planej"
    t.string   "fornecedor_regiao_planejamento"
    t.string   "unidade_gestora"
    t.string   "grupo_lote"
    t.string   "descricao_item_referencia"
    t.integer  "id_item_aquisicao"
    t.string   "cod_item_referencia"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "manager_id"
    t.decimal  "valor_total_calculated"
    t.index ["codigo_item"], name: "index_integration_purchases_purchases_on_codigo_item", using: :btree
    t.index ["data_finalizada"], name: "index_integration_purchases_purchases_on_data_finalizada", using: :btree
    t.index ["data_publicacao"], name: "index_integration_purchases_purchases_on_data_publicacao", using: :btree
    t.index ["descricao_item"], name: "index_integration_purchases_purchases_on_descricao_item", using: :btree
    t.index ["forma_aquisicao"], name: "index_integration_purchases_purchases_on_forma_aquisicao", using: :btree
    t.index ["manager_id"], name: "index_integration_purchases_purchases_on_manager_id", using: :btree
    t.index ["natureza_aquisicao"], name: "index_integration_purchases_purchases_on_natureza_aquisicao", using: :btree
    t.index ["nome_fornecedor"], name: "index_integration_purchases_purchases_on_nome_fornecedor", using: :btree
    t.index ["nome_grupo"], name: "index_integration_purchases_purchases_on_nome_grupo", using: :btree
    t.index ["nome_resp_compra"], name: "index_integration_purchases_purchases_on_nome_resp_compra", using: :btree
    t.index ["num_termo_participacao"], name: "index_integration_purchases_purchases_on_num_termo_participacao", using: :btree
    t.index ["numero_publicacao"], name: "index_integration_purchases_purchases_on_numero_publicacao", using: :btree
    t.index ["numero_viproc"], name: "index_integration_purchases_purchases_on_numero_viproc", using: :btree
    t.index ["sistematica_aquisicao"], name: "index_integration_purchases_purchases_on_sistematica_aquisicao", using: :btree
    t.index ["tipo_aquisicao"], name: "index_integration_purchases_purchases_on_tipo_aquisicao", using: :btree
  end

  create_table "integration_real_states_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.string   "headers_soap_action"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "detail_operation"
    t.string   "detail_response_path"
  end

  create_table "integration_real_states_real_states", force: :cascade do |t|
    t.integer  "manager_id"
    t.integer  "property_type_id"
    t.integer  "occupation_type_id"
    t.string   "service_id"
    t.string   "descricao_imovel"
    t.string   "estado"
    t.string   "municipio"
    t.decimal  "area_projecao_construcao"
    t.decimal  "area_medida_in_loco"
    t.decimal  "area_registrada"
    t.decimal  "frente"
    t.decimal  "fundo"
    t.decimal  "lateral_direita"
    t.decimal  "lateral_esquerda"
    t.decimal  "taxa_ocupacao"
    t.decimal  "fracao_ideal"
    t.string   "numero_imovel"
    t.string   "utm_zona"
    t.string   "bairro"
    t.string   "cep"
    t.string   "endereco"
    t.string   "complemento"
    t.string   "lote"
    t.string   "quadra"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["bairro"], name: "index_integration_real_states_real_states_on_bairro", using: :btree
    t.index ["cep"], name: "index_integration_real_states_real_states_on_cep", using: :btree
    t.index ["complemento"], name: "index_integration_real_states_real_states_on_complemento", using: :btree
    t.index ["descricao_imovel"], name: "index_integration_real_states_real_states_on_descricao_imovel", using: :btree
    t.index ["endereco"], name: "index_integration_real_states_real_states_on_endereco", using: :btree
    t.index ["lote"], name: "index_integration_real_states_real_states_on_lote", using: :btree
    t.index ["manager_id"], name: "index_integration_rs_real_states_on_integration_s_organs_id", using: :btree
    t.index ["municipio"], name: "index_integration_real_states_real_states_on_municipio", using: :btree
    t.index ["numero_imovel"], name: "index_integration_real_states_real_states_on_numero_imovel", using: :btree
    t.index ["occupation_type_id"], name: "index_integration_rs_real_states_on_occupation_types_id", using: :btree
    t.index ["property_type_id"], name: "index_integration_rs_real_states_on_property_types_id", using: :btree
    t.index ["quadra"], name: "index_integration_real_states_real_states_on_quadra", using: :btree
  end

  create_table "integration_results_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "user"
    t.string   "password"
    t.string   "strategic_indicator_response_path"
    t.string   "strategic_indicator_operation"
    t.string   "thematic_indicator_response_path"
    t.string   "thematic_indicator_operation"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.string   "headers_soap_action"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "integration_results_strategic_indicators", force: :cascade do |t|
    t.jsonb    "eixo"
    t.string   "resultado"
    t.string   "indicador"
    t.string   "unidade"
    t.string   "sigla_orgao"
    t.string   "orgao"
    t.jsonb    "valores_realizados"
    t.jsonb    "valores_atuais"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "organ_id"
    t.integer  "axis_id"
    t.index ["axis_id"], name: "index_ir_strategic_indicators_on_integration_s_axes_id", using: :btree
    t.index ["organ_id"], name: "index_ir_strategic_indicators_on_integration_s_organs_id", using: :btree
  end

  create_table "integration_results_thematic_indicators", force: :cascade do |t|
    t.jsonb    "eixo"
    t.jsonb    "tema"
    t.string   "resultado"
    t.string   "indicador"
    t.string   "unidade"
    t.string   "sigla_orgao"
    t.string   "orgao"
    t.jsonb    "valores_realizados"
    t.jsonb    "valores_programados"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "organ_id"
    t.integer  "axis_id"
    t.integer  "theme_id"
    t.index ["axis_id"], name: "index_ir_thematic_indicators_on_integration_s_axes_id", using: :btree
    t.index ["organ_id"], name: "index_ir_thematic_indicators_on_integration_s_organs_id", using: :btree
    t.index ["theme_id"], name: "index_ir_thematic_indicators_on_integration_s_themes_id", using: :btree
  end

  create_table "integration_revenues_account_configurations", force: :cascade do |t|
    t.string   "account_number"
    t.string   "title"
    t.integer  "integration_revenues_configuration_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["integration_revenues_configuration_id"], name: "index_revenues_on_configuration_id", using: :btree
  end

  create_table "integration_revenues_accounts", force: :cascade do |t|
    t.string   "conta_corrente"
    t.string   "natureza_credito"
    t.decimal  "valor_credito"
    t.string   "natureza_debito"
    t.decimal  "valor_debito"
    t.decimal  "valor_inicial"
    t.string   "natureza_inicial"
    t.string   "mes"
    t.integer  "integration_revenues_revenue_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "codigo_natureza_receita"
    t.index ["codigo_natureza_receita"], name: "ira_codigo_natureza_receita", using: :btree
    t.index ["conta_corrente"], name: "index_integration_revenues_accounts_on_conta_corrente", using: :btree
    t.index ["integration_revenues_revenue_id"], name: "index_revenues_on_revenue_id", using: :btree
  end

  create_table "integration_revenues_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "headers_soap_action"
    t.string   "month"
  end

  create_table "integration_revenues_revenues", force: :cascade do |t|
    t.string   "unidade"
    t.string   "poder"
    t.string   "administracao"
    t.string   "conta_contabil"
    t.string   "titulo"
    t.string   "natureza_da_conta"
    t.string   "natureza_credito"
    t.decimal  "valor_credito"
    t.string   "natureza_debito"
    t.decimal  "valor_debito"
    t.decimal  "valor_inicial"
    t.string   "natureza_inicial"
    t.string   "fechamento_contabil"
    t.string   "data_atual"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "integration_revenues_account_configuration_id"
    t.integer  "month"
    t.integer  "year"
    t.integer  "integration_supports_organ_id"
    t.integer  "integration_supports_secretary_id"
    t.integer  "account_type"
    t.index ["account_type"], name: "irr_account_type", using: :btree
    t.index ["integration_revenues_account_configuration_id"], name: "index_revenues_on_account_configuration_id", using: :btree
    t.index ["integration_supports_organ_id"], name: "irr_organ_id", using: :btree
    t.index ["integration_supports_secretary_id"], name: "irr_secretary_id", using: :btree
  end

  create_table "integration_servers_configurations", force: :cascade do |t|
    t.string   "arqfun_ftp_address",                     null: false
    t.string   "arqfun_ftp_user",                        null: false
    t.string   "arqfun_ftp_password",                    null: false
    t.string   "arqfin_ftp_address",                     null: false
    t.string   "arqfin_ftp_user",                        null: false
    t.string   "arqfin_ftp_password",                    null: false
    t.string   "rubricas_ftp_address",                   null: false
    t.string   "rubricas_ftp_user",                      null: false
    t.string   "rubricas_ftp_password",                  null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "arqfun_ftp_dir"
    t.string   "arqfin_ftp_dir"
    t.string   "rubricas_ftp_dir"
    t.integer  "status"
    t.datetime "last_importation"
    t.string   "log"
    t.boolean  "arqfun_ftp_passive",     default: false, null: false
    t.boolean  "arqfin_ftp_passive",     default: false, null: false
    t.boolean  "rubricas_ftp_passive",   default: false, null: false
    t.string   "month"
    t.string   "metrofor_ftp_user"
    t.string   "metrofor_password_user"
    t.index ["deleted_at"], name: "index_integration_servers_configurations_on_deleted_at", using: :btree
  end

  create_table "integration_servers_proceed_types", force: :cascade do |t|
    t.string   "cod_provento"
    t.string   "dsc_tipo"
    t.string   "dsc_provento"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "origin"
    t.index "upper((dsc_tipo)::text)", name: "index_integration_servers_proceed_types_on_dsc_tipo", using: :btree
    t.index ["cod_provento"], name: "index_integration_servers_proceed_types_on_cod_provento", using: :btree
  end

  create_table "integration_servers_proceeds", force: :cascade do |t|
    t.integer  "num_ano"
    t.integer  "num_mes"
    t.string   "cod_processamento"
    t.decimal  "vlr_financeiro"
    t.decimal  "vlr_vencimento"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "cod_orgao"
    t.string   "dsc_matricula"
    t.string   "cod_provento"
    t.string   "full_matricula"
    t.index ["cod_provento", "cod_processamento", "num_ano", "num_mes", "cod_orgao", "dsc_matricula"], name: "integration_servers_proceeds_pk_index", using: :btree
    t.index ["cod_provento"], name: "isp_cod_provento", using: :btree
    t.index ["full_matricula", "num_ano", "num_mes"], name: "index_for_full_matricula_num_ano_num_mes", using: :btree
    t.index ["full_matricula"], name: "isp_full_matricula", using: :btree
    t.index ["num_ano"], name: "isp_num_ano", using: :btree
    t.index ["num_mes", "num_ano"], name: "index_integration_servers_proceeds_on_num_mes_and_num_ano", using: :btree
    t.index ["num_mes"], name: "isp_num_mes", using: :btree
  end

  create_table "integration_servers_registrations", force: :cascade do |t|
    t.string   "dsc_matricula"
    t.string   "dsc_cpf"
    t.string   "dsc_funcionario"
    t.string   "cod_orgao"
    t.string   "dsc_cargo"
    t.string   "num_folha"
    t.string   "cod_situacao_funcional"
    t.string   "cod_afastamento"
    t.decimal  "vlr_carga_horaria",         precision: 5, scale: 2
    t.date     "dth_nascimento"
    t.date     "dth_afastamento"
    t.date     "vdth_admissao"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "status_situacao_funcional"
    t.integer  "functional_status"
    t.boolean  "active_functional_status"
    t.string   "full_matricula"
    t.index ["active_functional_status"], name: "index_isr_on_active_functional_status", where: "(active_functional_status IS TRUE)", using: :btree
    t.index ["cod_orgao"], name: "index_integration_servers_registrations_on_cod_orgao", using: :btree
    t.index ["cod_situacao_funcional"], name: "isr_cod_situacao_funcional", using: :btree
    t.index ["dsc_cpf"], name: "isr_dsc_cpf", using: :btree
    t.index ["dsc_matricula", "cod_orgao"], name: "index_for_import_process_dsc_matricula_cod_orgao", using: :btree
    t.index ["dsc_matricula"], name: "index_integration_servers_registrations_on_dsc_matricula", using: :btree
    t.index ["full_matricula"], name: "isr_full_matricula", using: :btree
    t.index ["functional_status"], name: "isr_functional_status", using: :btree
    t.index ["status_situacao_funcional"], name: "isr_status_situacao_funcional", using: :btree
  end

  create_table "integration_servers_server_salaries", force: :cascade do |t|
    t.integer  "integration_servers_registration_id"
    t.decimal  "income_total",                        precision: 10, scale: 2
    t.decimal  "income_final",                        precision: 10, scale: 2
    t.decimal  "income_dailies",                      precision: 10, scale: 2
    t.decimal  "discount_total",                      precision: 10, scale: 2
    t.decimal  "discount_under_roof",                 precision: 10, scale: 2
    t.decimal  "discount_others",                     precision: 10, scale: 2
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.integer  "integration_supports_server_role_id"
    t.string   "server_name"
    t.date     "date"
    t.integer  "status"
    t.string   "cod_situacao_funcional"
    t.integer  "functional_status"
    t.string   "status_situacao_funcional"
    t.index ["cod_situacao_funcional"], name: "index_for_server_salaries_cod_sit_fun", using: :btree
    t.index ["date", "functional_status"], name: "index_for_server_salaries_date_func_stat", using: :btree
    t.index ["date"], name: "isss_date", using: :btree
    t.index ["functional_status"], name: "index_integration_servers_server_salaries_on_functional_status", using: :btree
    t.index ["integration_servers_registration_id"], name: "isss_registration_id", using: :btree
    t.index ["integration_supports_server_role_id"], name: "isss_role_id", using: :btree
    t.index ["server_name"], name: "index_integration_servers_server_salaries_on_server_name", using: :btree
    t.index ["status"], name: "index_integration_servers_server_salaries_on_status", using: :btree
    t.index ["status_situacao_funcional"], name: "index_for_server_salaries_sit_fun", using: :btree
    t.index ["updated_at"], name: "index_integration_servers_server_salaries_on_updated_at", using: :btree
  end

  create_table "integration_servers_servers", force: :cascade do |t|
    t.string   "dsc_cpf"
    t.string   "dsc_funcionario"
    t.date     "dth_nascimento"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["dsc_cpf"], name: "index_integration_servers_servers_on_dsc_cpf", using: :btree
    t.index ["dsc_funcionario"], name: "index_integration_servers_servers_on_dsc_funcionario", using: :btree
  end

  create_table "integration_supports_administrative_regions", force: :cascade do |t|
    t.string "codigo_regiao"
    t.string "titulo"
    t.string "codigo_regiao_resumido"
    t.index ["codigo_regiao"], name: "isar_codigo_regiao", using: :btree
    t.index ["codigo_regiao_resumido"], name: "isar_codigo_regiao_resumido", using: :btree
  end

  create_table "integration_supports_application_modalities", force: :cascade do |t|
    t.string "codigo_modalidade"
    t.string "titulo"
    t.index ["codigo_modalidade"], name: "isam_codigo_modalidade", using: :btree
  end

  create_table "integration_supports_axes", force: :cascade do |t|
    t.string "codigo_eixo"
    t.string "descricao_eixo"
    t.index ["codigo_eixo"], name: "ist_codigo_eixo", using: :btree
  end

  create_table "integration_supports_axis_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.string   "headers_soap_action"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_supports_budget_units", force: :cascade do |t|
    t.string "codigo_unidade_gestora"
    t.string "codigo_unidade_orcamentaria"
    t.string "titulo"
    t.index ["codigo_unidade_gestora"], name: "isbu_codigo_unidade_gestora", using: :btree
    t.index ["codigo_unidade_orcamentaria"], name: "isbu_codigo_unidade_orcamentaria", using: :btree
  end

  create_table "integration_supports_creditor_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.date     "started_at"
    t.date     "finished_at"
  end

  create_table "integration_supports_creditors", force: :cascade do |t|
    t.string   "bairro"
    t.string   "cep"
    t.string   "codigo"
    t.string   "codigo_contribuinte"
    t.string   "codigo_distrito"
    t.string   "codigo_municipio"
    t.string   "codigo_nit"
    t.string   "codigo_pis_pasep"
    t.string   "complemento"
    t.string   "cpf_cnpj"
    t.string   "data_atual"
    t.string   "data_cadastro"
    t.string   "email"
    t.string   "logradouro"
    t.string   "nome"
    t.string   "nome_municipio"
    t.string   "numero"
    t.string   "status"
    t.string   "telefone_contato"
    t.string   "uf"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["codigo"], name: "index_integration_supports_creditors_on_codigo", using: :btree
    t.index ["cpf_cnpj"], name: "isc_cpf_cnpj", using: :btree
    t.index ["nome"], name: "index_integration_supports_creditors_on_nome", using: :btree
  end

  create_table "integration_supports_domain_configurations", force: :cascade do |t|
    t.integer  "year"
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_supports_economic_categories", force: :cascade do |t|
    t.string "codigo_categoria_economica"
    t.string "titulo"
    t.index ["codigo_categoria_economica"], name: "isec_codigo_categoria_economica", using: :btree
  end

  create_table "integration_supports_expense_elements", force: :cascade do |t|
    t.string  "codigo_elemento_despesa"
    t.boolean "eh_elementar"
    t.boolean "eh_licitacao"
    t.boolean "eh_transferencia"
    t.string  "titulo"
    t.index ["codigo_elemento_despesa"], name: "isee_codigo_elemento_despesa", using: :btree
    t.index ["eh_elementar"], name: "isee_eh_elementar", using: :btree
    t.index ["eh_licitacao"], name: "isee_eh_licitacao", using: :btree
    t.index ["eh_transferencia"], name: "isee_eh_transferencia", using: :btree
  end

  create_table "integration_supports_expense_nature_groups", force: :cascade do |t|
    t.string "codigo_grupo_natureza"
    t.string "titulo"
    t.index ["codigo_grupo_natureza"], name: "iseng_codigo_grupo_natureza", using: :btree
  end

  create_table "integration_supports_expense_nature_items", force: :cascade do |t|
    t.string "codigo_item_natureza"
    t.string "titulo"
    t.index ["codigo_item_natureza"], name: "iseni_codigo_item_natureza", using: :btree
  end

  create_table "integration_supports_expense_natures", force: :cascade do |t|
    t.string "codigo_natureza_despesa"
    t.string "titulo"
    t.index ["codigo_natureza_despesa"], name: "isen_codigo_natureza_despesa", using: :btree
  end

  create_table "integration_supports_expense_types", force: :cascade do |t|
    t.string "codigo"
    t.index ["codigo"], name: "iset_codigo", using: :btree
  end

  create_table "integration_supports_finance_groups", force: :cascade do |t|
    t.string "codigo_grupo_financeiro"
    t.string "titulo"
    t.index ["codigo_grupo_financeiro"], name: "isfg_codigo_grupo_financeiro", using: :btree
  end

  create_table "integration_supports_functions", force: :cascade do |t|
    t.string "codigo_funcao"
    t.string "titulo"
    t.index ["codigo_funcao"], name: "isf_codigo_funcao", using: :btree
  end

  create_table "integration_supports_government_actions", force: :cascade do |t|
    t.string "codigo_acao"
    t.string "titulo"
    t.index ["codigo_acao"], name: "isga_codigo_acao", using: :btree
  end

  create_table "integration_supports_government_programs", force: :cascade do |t|
    t.integer "ano_inicio"
    t.string  "codigo_programa"
    t.string  "titulo"
    t.index ["ano_inicio"], name: "isgp_ano_inicio", using: :btree
    t.index ["codigo_programa"], name: "isgp_codigo_programa", using: :btree
  end

  create_table "integration_supports_legal_devices", force: :cascade do |t|
    t.string "codigo"
    t.text   "descricao"
    t.index ["codigo"], name: "isld_codigo", using: :btree
  end

  create_table "integration_supports_management_units", force: :cascade do |t|
    t.string "cgf"
    t.string "cnpj"
    t.string "codigo"
    t.string "codigo_credor"
    t.string "poder"
    t.string "sigla"
    t.string "tipo_administracao"
    t.string "tipo_de_ug"
    t.string "titulo"
    t.index ["cgf"], name: "ismu_cgf", using: :btree
    t.index ["cnpj"], name: "ismu_cnpj", using: :btree
    t.index ["codigo"], name: "ismu_codigo", using: :btree
    t.index ["codigo_credor"], name: "ismu_codigo_credor", using: :btree
    t.index ["poder"], name: "ismu_poder", using: :btree
    t.index ["sigla"], name: "ismu_sigla", using: :btree
    t.index ["tipo_administracao"], name: "ismu_tipo_administracao", using: :btree
    t.index ["tipo_de_ug"], name: "ismu_tipo_de_ug", using: :btree
  end

  create_table "integration_supports_organ_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_supports_organ_server_roles", force: :cascade do |t|
    t.integer "integration_supports_organ_id"
    t.integer "integration_supports_server_role_id"
    t.index ["integration_supports_organ_id"], name: "ososr_organ_id", using: :btree
    t.index ["integration_supports_server_role_id"], name: "ososr_server_role_id", using: :btree
  end

  create_table "integration_supports_organs", force: :cascade do |t|
    t.string   "codigo_orgao"
    t.string   "descricao_orgao"
    t.string   "sigla"
    t.string   "codigo_entidade"
    t.string   "descricao_entidade"
    t.string   "descricao_administracao"
    t.string   "poder"
    t.string   "codigo_folha_pagamento"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "orgao_sfp"
    t.date     "data_inicio"
    t.date     "data_termino"
    t.boolean  "secretary"
    t.index ["codigo_entidade"], name: "index_integration_supports_organs_on_codigo_entidade", using: :btree
    t.index ["codigo_folha_pagamento"], name: "index_integration_supports_organs_on_codigo_folha_pagamento", using: :btree
    t.index ["codigo_orgao", "data_termino", "codigo_folha_pagamento"], name: "index_iso_co_dt_cfp", using: :btree
    t.index ["codigo_orgao", "data_termino", "orgao_sfp"], name: "index_iso_co_dt_sfp", using: :btree
    t.index ["codigo_orgao"], name: "index_integration_supports_organs_on_codigo_orgao", using: :btree
    t.index ["data_inicio"], name: "iso_data_inicio", using: :btree
    t.index ["data_termino"], name: "iso_data_termino", using: :btree
    t.index ["orgao_sfp"], name: "index_integration_supports_organs_on_orgao_sfp", using: :btree
    t.index ["secretary"], name: "iso_secretary", using: :btree
    t.index ["sigla"], name: "index_integration_supports_organs_on_sigla", using: :btree
  end

  create_table "integration_supports_payment_retention_types", force: :cascade do |t|
    t.string "codigo_retencao"
    t.string "titulo"
    t.index ["codigo_retencao"], name: "isprt_codigo_retencao", using: :btree
  end

  create_table "integration_supports_products", force: :cascade do |t|
    t.string "codigo"
    t.string "titulo"
    t.index ["codigo"], name: "isp_codigo", using: :btree
  end

  create_table "integration_supports_qualified_resource_sources", force: :cascade do |t|
    t.string "codigo"
    t.string "titulo"
    t.index ["codigo"], name: "isqrs_codigo", using: :btree
  end

  create_table "integration_supports_real_states_occupation_types", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_integration_sup_real_states_occupation_types_on_title", using: :btree
  end

  create_table "integration_supports_real_states_property_types", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_integration_sup_real_states_property_types_on_title", using: :btree
  end

  create_table "integration_supports_resource_sources", force: :cascade do |t|
    t.string "codigo_fonte"
    t.string "titulo"
    t.index ["codigo_fonte"], name: "isrs_codigo_fonte", using: :btree
  end

  create_table "integration_supports_revenue_natures", force: :cascade do |t|
    t.string  "codigo"
    t.string  "descricao"
    t.integer "revenue_nature_type"
    t.string  "codigo_consolidado"
    t.string  "codigo_categoria_economica"
    t.string  "codigo_origem"
    t.string  "codigo_subfonte"
    t.string  "codigo_rubrica"
    t.string  "codigo_alinea"
    t.string  "codigo_subalinea"
    t.boolean "transfer_voluntary"
    t.boolean "transfer_required"
    t.text    "full_title"
    t.string  "unique_id_consolidado"
    t.string  "unique_id_categoria_economica"
    t.string  "unique_id_origem"
    t.string  "unique_id_subfonte"
    t.string  "unique_id_rubrica"
    t.string  "unique_id_alinea"
    t.string  "unique_id_subalinea"
    t.string  "unique_id"
    t.integer "year"
    t.index ["codigo"], name: "isrn_codigo", using: :btree
    t.index ["codigo_alinea"], name: "isrn_codigo_alinea", using: :btree
    t.index ["codigo_categoria_economica"], name: "isrn_codigo_categoria_economica", using: :btree
    t.index ["codigo_consolidado"], name: "isrn_codigo_consolidado", using: :btree
    t.index ["codigo_origem"], name: "isrn_codigo_origem", using: :btree
    t.index ["codigo_rubrica"], name: "isrn_codigo_rubrica", using: :btree
    t.index ["codigo_subalinea"], name: "isrn_codigo_subalinea", using: :btree
    t.index ["codigo_subfonte"], name: "isrn_codigo_subfonte", using: :btree
    t.index ["revenue_nature_type"], name: "isrn_revenue_nature_type", using: :btree
    t.index ["transfer_required"], name: "isrn_transfer_required", using: :btree
    t.index ["transfer_voluntary"], name: "isrn_transfer_voluntary", using: :btree
    t.index ["unique_id"], name: "isrn_unique_id", using: :btree
    t.index ["unique_id_alinea"], name: "isrn_unique_id_alinea", using: :btree
    t.index ["unique_id_categoria_economica"], name: "isrn_unique_id_categoria_economica", using: :btree
    t.index ["unique_id_consolidado"], name: "isrn_unique_id_consolidado", using: :btree
    t.index ["unique_id_origem"], name: "isrn_unique_id_origem", using: :btree
    t.index ["unique_id_rubrica"], name: "isrn_unique_id_rubrica", using: :btree
    t.index ["unique_id_subalinea"], name: "isrn_unique_id_subalinea", using: :btree
    t.index ["unique_id_subfonte"], name: "isrn_unique_id_subfonte", using: :btree
    t.index ["year"], name: "index_integration_supports_revenue_natures_on_year", using: :btree
  end

  create_table "integration_supports_server_roles", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_integration_supports_server_roles_on_name", using: :btree
  end

  create_table "integration_supports_sub_functions", force: :cascade do |t|
    t.string "codigo_sub_funcao"
    t.string "titulo"
    t.index ["codigo_sub_funcao"], name: "issf_codigo_sub_funcao", using: :btree
  end

  create_table "integration_supports_sub_products", force: :cascade do |t|
    t.string "codigo"
    t.string "codigo_produto"
    t.string "titulo"
    t.index ["codigo"], name: "issp_codigo", using: :btree
    t.index ["codigo_produto"], name: "issp_codigo_produto", using: :btree
  end

  create_table "integration_supports_theme_configurations", force: :cascade do |t|
    t.string   "wsdl"
    t.string   "headers_soap_action"
    t.string   "user"
    t.string   "password"
    t.string   "operation"
    t.string   "response_path"
    t.integer  "status"
    t.datetime "last_importation"
    t.text     "log"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "integration_supports_themes", force: :cascade do |t|
    t.string "codigo_tema"
    t.string "descricao_tema"
    t.index ["codigo_tema"], name: "ist_codigo_tema", using: :btree
  end

  create_table "integration_supports_undertakings", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["descricao"], name: "index_integration_supports_undertakings_on_descricao", using: :btree
  end

  create_table "integration_utils_data_changes", force: :cascade do |t|
    t.jsonb    "data_changes"
    t.integer  "changeable_id"
    t.string   "changeable_type"
    t.integer  "resource_status", default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["changeable_id", "changeable_type"], name: "index_i_u_dc_changeable", using: :btree
    t.index ["resource_status", "changeable_id", "changeable_type"], name: "index_i_u_dc_resource_status_changeable", using: :btree
    t.index ["resource_status"], name: "index_integration_utils_data_changes_on_resource_status", using: :btree
  end

  create_table "open_data_data_items", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "data_item_type"
    t.integer  "open_data_data_set_id"
    t.string   "response_path"
    t.string   "wsdl"
    t.string   "operation"
    t.string   "parameters"
    t.string   "headers_soap_action"
    t.integer  "status"
    t.string   "document_public_filename"
    t.string   "document_format"
    t.string   "document_id"
    t.string   "document_filename"
    t.string   "document_content_size"
    t.string   "document_content_type"
    t.datetime "processed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "last_error"
    t.index ["data_item_type"], name: "oddi_data_item_type", using: :btree
    t.index ["open_data_data_set_id"], name: "oddi_open_data_data_set_id", using: :btree
    t.index ["status"], name: "oddi_status", using: :btree
  end

  create_table "open_data_data_set_vcge_categories", force: :cascade do |t|
    t.integer "open_data_data_set_id"
    t.integer "open_data_vcge_category_id"
    t.index ["open_data_data_set_id"], name: "odds_open_data_set_id", using: :btree
    t.index ["open_data_vcge_category_id"], name: "odds_vcge_category_id", using: :btree
  end

  create_table "open_data_data_sets", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "source_catalog"
    t.integer  "organ_id"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["organ_id"], name: "index_open_data_data_sets_on_organ_id", using: :btree
  end

  create_table "open_data_vcge_categories", force: :cascade do |t|
    t.string "title"
    t.string "href"
    t.string "name"
    t.string "vcge_id"
    t.index ["vcge_id"], name: "index_open_data_vcge_categories_on_vcge_id", using: :btree
  end

  create_table "open_data_vcge_category_associations", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.index ["child_id"], name: "index_open_data_vcge_category_associations_on_child_id", using: :btree
    t.index ["parent_id"], name: "index_open_data_vcge_category_associations_on_parent_id", using: :btree
  end

  create_table "ppa_source_axis_themes", force: :cascade do |t|
    t.string   "codigo_eixo"
    t.string   "descricao_eixo"
    t.string   "codigo_tema"
    t.string   "descricao_tema"
    t.string   "descricao_tema_detalhado"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["codigo_eixo", "codigo_tema"], name: "index_ppa_source_axis_themes_on_codigo_eixo_and_codigo_tema", unique: true, using: :btree
    t.index ["codigo_eixo"], name: "index_ppa_source_axis_themes_on_codigo_eixo", using: :btree
    t.index ["codigo_tema"], name: "index_ppa_source_axis_themes_on_codigo_tema", using: :btree
  end

  create_table "ppa_source_guidelines", force: :cascade do |t|
    t.string   "codigo_regiao"
    t.string   "descricao_regiao"
    t.string   "descricao_objetivo_estrategico"
    t.string   "descricao_estrategia"
    t.string   "codigo_ppa_objetivo_estrategico"
    t.string   "codigo_ppa_estrategia"
    t.string   "codigo_eixo"
    t.string   "descricao_eixo"
    t.string   "codigo_tema"
    t.string   "descricao_tema"
    t.string   "codigo_programa"
    t.string   "descricao_programa"
    t.string   "codigo_ppa_iniciativa"
    t.string   "descricao_ppa_iniciativa"
    t.string   "codigo_acao"
    t.string   "descricao_acao"
    t.string   "codigo_produto"
    t.string   "descricao_produto"
    t.string   "descricao_portal"
    t.string   "prioridade_regional"
    t.string   "ordem_prioridade"
    t.string   "descricao_referencia"
    t.decimal  "valor_programado_ano1"
    t.decimal  "valor_programado_ano2"
    t.decimal  "valor_programado_ano3"
    t.decimal  "valor_programado_ano4"
    t.decimal  "valor_programado1619_ar"
    t.decimal  "valor_programado1619_dr"
    t.decimal  "valor_realizado_ano1"
    t.decimal  "valor_realizado_ano2"
    t.decimal  "valor_realizado_ano3"
    t.decimal  "valor_realizado_ano4"
    t.decimal  "valor_realizado1619_ar"
    t.decimal  "valor_realizado1619_dr"
    t.integer  "ano"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.decimal  "valor_lei_ano1"
    t.decimal  "valor_lei_ano2"
    t.decimal  "valor_lei_ano3"
    t.decimal  "valor_lei_ano4"
    t.decimal  "valor_lei_creditos_ano1"
    t.decimal  "valor_lei_creditos_ano2"
    t.decimal  "valor_lei_creditos_ano3"
    t.decimal  "valor_lei_creditos_ano4"
    t.decimal  "valor_empenhado_ano1"
    t.decimal  "valor_empenhado_ano2"
    t.decimal  "valor_empenhado_ano3"
    t.decimal  "valor_empenhado_ano4"
    t.decimal  "valor_pago_ano1"
    t.decimal  "valor_pago_ano2"
    t.decimal  "valor_pago_ano3"
    t.decimal  "valor_pago_ano4"
    t.index ["ano", "codigo_regiao", "codigo_eixo", "codigo_tema", "codigo_ppa_objetivo_estrategico", "codigo_ppa_estrategia", "codigo_programa", "codigo_ppa_iniciativa", "codigo_acao", "codigo_produto", "descricao_referencia"], name: "index_ppa_source_guidelines_uniqueness", unique: true, using: :btree
    t.index ["ano"], name: "index_ppa_source_guidelines_on_ano", using: :btree
    t.index ["codigo_eixo"], name: "index_ppa_source_guidelines_on_codigo_eixo", using: :btree
    t.index ["codigo_ppa_estrategia"], name: "index_ppa_source_guidelines_on_codigo_ppa_estrategia", using: :btree
    t.index ["codigo_ppa_iniciativa"], name: "index_ppa_source_guidelines_on_codigo_ppa_iniciativa", using: :btree
    t.index ["codigo_ppa_objetivo_estrategico"], name: "index_ppa_source_guidelines_on_codigo_ppa_objetivo_estrategico", using: :btree
    t.index ["codigo_produto"], name: "index_ppa_source_guidelines_on_codigo_produto", using: :btree
    t.index ["codigo_regiao"], name: "index_ppa_source_guidelines_on_codigo_regiao", using: :btree
    t.index ["codigo_tema"], name: "index_ppa_source_guidelines_on_codigo_tema", using: :btree
  end

  create_table "ppa_source_regions", force: :cascade do |t|
    t.string   "codigo_regiao"
    t.string   "descricao_regiao"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["codigo_regiao"], name: "index_ppa_source_regions_on_codigo_regiao", unique: true, using: :btree
  end

  create_table "schedules", force: :cascade do |t|
    t.string   "cron_syntax_frequency"
    t.string   "scheduleable_type"
    t.integer  "scheduleable_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["scheduleable_type", "scheduleable_id"], name: "index_schedules_on_scheduleable_type_and_scheduleable_id", using: :btree
  end

  create_table "stats", force: :cascade do |t|
    t.string   "type"
    t.integer  "month"
    t.integer  "year"
    t.text     "data"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "month_start"
    t.integer  "month_end"
    t.index ["month"], name: "index_stats_on_month", using: :btree
    t.index ["type"], name: "index_stats_on_type", using: :btree
    t.index ["year", "type", "month"], name: "index_stats_on_year_and_type_and_month", using: :btree
    t.index ["year", "type", "month_start", "month_end"], name: "index_stats_on_year_and_type_and_month_start_and_month_end", using: :btree
    t.index ["year"], name: "index_stats_on_year", using: :btree
  end

  create_table "stats_server_salaries", force: :cascade do |t|
    t.integer  "month"
    t.integer  "year"
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["month"], name: "index_stats_server_salaries_on_month", using: :btree
    t.index ["year"], name: "index_stats_server_salaries_on_year", using: :btree
  end

  create_table "transparency_exports", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "query"
    t.string   "resource_name"
    t.string   "filename"
    t.integer  "status"
    t.datetime "expiration"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "worksheet_format"
  end

  create_table "transparency_followers", force: :cascade do |t|
    t.string   "email"
    t.integer  "resourceable_id"
    t.string   "resourceable_type"
    t.string   "transparency_link"
    t.datetime "unsubscribed_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["email"], name: "index_transparency_followers_on_email", using: :btree
    t.index ["resourceable_id", "resourceable_type"], name: "index_t_f_resourceable", using: :btree
    t.index ["unsubscribed_at"], name: "index_transparency_followers_on_unsubscribed_at", using: :btree
  end

  create_table "transparency_survey_answers", force: :cascade do |t|
    t.string   "transparency_page"
    t.integer  "answer"
    t.date     "date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "email"
    t.text     "message"
    t.string   "controller"
    t.string   "action"
    t.text     "url"
    t.integer  "evaluation_note"
    t.index ["action"], name: "index_transparency_survey_answers_on_action", using: :btree
    t.index ["answer"], name: "tsa_answer", using: :btree
    t.index ["controller"], name: "index_transparency_survey_answers_on_controller", using: :btree
    t.index ["date"], name: "tsa_date", using: :btree
    t.index ["transparency_page"], name: "tsa_transparency_page", using: :btree
  end

  add_foreign_key "integration_city_undertakings_city_undertakings", "integration_supports_creditors", column: "creditor_id"
  add_foreign_key "integration_city_undertakings_city_undertakings", "integration_supports_organs", column: "organ_id"
  add_foreign_key "integration_city_undertakings_city_undertakings", "integration_supports_undertakings", column: "undertaking_id"
  add_foreign_key "integration_constructions_dae_measurements", "integration_constructions_daes"
  add_foreign_key "integration_constructions_dae_photos", "integration_constructions_daes"
  add_foreign_key "integration_constructions_daes", "integration_supports_organs", column: "organ_id"
  add_foreign_key "integration_constructions_der_measurements", "integration_constructions_ders"
  add_foreign_key "integration_macroregions_macroregion_investiments", "integration_macroregions_powers", column: "power_id"
  add_foreign_key "integration_macroregions_macroregion_investiments", "integration_macroregions_regions", column: "region_id"
  add_foreign_key "integration_purchases_purchases", "integration_supports_management_units", column: "manager_id"
  add_foreign_key "integration_real_states_real_states", "integration_supports_organs", column: "manager_id"
  add_foreign_key "integration_real_states_real_states", "integration_supports_real_states_occupation_types", column: "occupation_type_id"
  add_foreign_key "integration_real_states_real_states", "integration_supports_real_states_property_types", column: "property_type_id"
  add_foreign_key "integration_results_strategic_indicators", "integration_supports_axes", column: "axis_id"
  add_foreign_key "integration_results_strategic_indicators", "integration_supports_organs", column: "organ_id"
  add_foreign_key "integration_results_thematic_indicators", "integration_supports_axes", column: "axis_id"
  add_foreign_key "integration_results_thematic_indicators", "integration_supports_organs", column: "organ_id"
  add_foreign_key "integration_results_thematic_indicators", "integration_supports_themes", column: "theme_id"
end
