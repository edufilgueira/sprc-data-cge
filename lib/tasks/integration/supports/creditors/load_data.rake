#
# Rake para importar dados legados de Credores que não vem no WebService.
#
# Para usar:
#
# > rake integration:supports:creditors:load_data file=/path/to/creditors.csv
#

namespace :integration do
  namespace :supports do
    namespace :creditors do
      task load_data: :environment do
        file = ENV['file']

        if file.blank?
          puts 'Arquivo de credores não definido (file=...)'
          exit 1
        end

        # Mapeamento das columns Dump -> WebService

        columns_map = {
          cod_credor: :codigo,
          nome_credor: :nome,
          cod_contribuinte: :codigo_contribuinte,
          cod_municipio: :codigo_municipio,
          telefone: :telefone_contato,
          dt_atual: :data_atual,
          dt_cadastro: :data_cadastro,
          codigoPisPasep: :codigo_pis_pasep
        }.with_indifferent_access

        imported = 0
        blank_cpf = 0
        with_validation_errors = 0

        CSV.foreach(file, headers: true) do |row|
          attributes = row.to_hash.map do |column|
            column_name = column[0]
            column_value = column[1]

            if columns_map.keys.include?(column_name)
              column_name = columns_map[column_name]
            end

            [column_name, column_value]
          end.to_h.with_indifferent_access

          if attributes[:cpf_cnpj].blank?
            blank_cpf += 1
            next
          end

          creditor = Integration::Supports::Creditor.find_or_initialize_by(cpf_cnpj: attributes[:cpf_cnpj])

          # Só importamos o que ainda não existe!

          if creditor.new_record?
            imported += 1

            creditor.assign_attributes(attributes)
            unless creditor.save
              with_validation_errors += 1
            end
          end
        end

        # Atualiza códigos para terem 8 caracteres, completando com zero à esquerda

        ActiveRecord::Base.connection.execute("UPDATE integration_supports_creditors SET codigo = LPAD(codigo, 8, '0') WHERE (LENGTH(codigo) < 8)")

        puts "Credores com erro de validação: #{with_validation_errors}"
        puts "Credores com cpf_cnpf em branco: #{blank_cpf}"
        puts "Credores importados: #{imported}"
      end
    end
  end
end
