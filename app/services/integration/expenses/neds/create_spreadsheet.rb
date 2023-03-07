#
# Cria planilha de despesas
#

class Integration::Expenses::Neds::CreateSpreadsheet < ::Integration::Expenses::BaseCreateSpreadsheet

  private

  def transparency_id
    :ned
  end

  def resource_klass
    Integration::Expenses::Ned
  end

  def file_name_prefix
    :notas_de_empenho
  end

  def presenter_klass
    Integration::Expenses::Ned::SpreadsheetPresenter
  end

  def resources
    resource_klass.
      from_executivo.
      from_year(year).
      ordinarias
  end
end
