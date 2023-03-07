#
# Initializer para configuração dos diferentes bancos de dados entre a
# aplicação principal (SPRC) e aplicação específica (SPRC Data)
#

database_config_file = File.open(Rails.root.join('config','database.yml'))
database_config = YAML::load(database_config_file)
sprc_database_config = database_config['sprc']
etl_integration_database_config = database_config['etl_integration']

if sprc_database_config.blank?
  puts '[ERRO] É preciso configurar o banco de dados de data em database.yml.'
  exit
else
  # constante global para config do database data
  SPRC_DATABASE_CONFIG = sprc_database_config[Rails.env]
  ETL_INTEGRATION_DATABASE_CONFIG = etl_integration_database_config[Rails.env]
end