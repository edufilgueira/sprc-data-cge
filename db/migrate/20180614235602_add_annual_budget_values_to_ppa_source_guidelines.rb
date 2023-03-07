class AddAnnualBudgetValuesToPPASourceGuidelines < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_source_guidelines, :valor_lei_ano1,          :decimal
    add_column :ppa_source_guidelines, :valor_lei_ano2,          :decimal
    add_column :ppa_source_guidelines, :valor_lei_ano3,          :decimal
    add_column :ppa_source_guidelines, :valor_lei_ano4,          :decimal
    add_column :ppa_source_guidelines, :valor_lei_creditos_ano1, :decimal
    add_column :ppa_source_guidelines, :valor_lei_creditos_ano2, :decimal
    add_column :ppa_source_guidelines, :valor_lei_creditos_ano3, :decimal
    add_column :ppa_source_guidelines, :valor_lei_creditos_ano4, :decimal
    add_column :ppa_source_guidelines, :valor_empenhado_ano1,    :decimal
    add_column :ppa_source_guidelines, :valor_empenhado_ano2,    :decimal
    add_column :ppa_source_guidelines, :valor_empenhado_ano3,    :decimal
    add_column :ppa_source_guidelines, :valor_empenhado_ano4,    :decimal
    add_column :ppa_source_guidelines, :valor_pago_ano1,         :decimal
    add_column :ppa_source_guidelines, :valor_pago_ano2,         :decimal
    add_column :ppa_source_guidelines, :valor_pago_ano3,         :decimal
    add_column :ppa_source_guidelines, :valor_pago_ano4,         :decimal

    remove_column :ppa_source_guidelines, :valor_lei,          :decimal
    remove_column :ppa_source_guidelines, :valor_lei_creditos, :decimal
    remove_column :ppa_source_guidelines, :valor_empenhado,    :decimal
    remove_column :ppa_source_guidelines, :valor_pago,         :decimal
  end
end
