#
# Importador de dados do Web Service de NLD
#
class Integration::Expenses::NldImporter < Integration::Expenses::BaseExpensesImporter

  private

  def model_klass
    Integration::Expenses::Nld
  end

  def create_stats_klass
    Integration::Expenses::Nlds::CreateStats
  end

  def import_nld(attributes, line)
    nld = find_or_initializer(model_klass, attributes)

    deleted_list_attributes = remove_lists_attributes(attributes)

    update(nld, attributes, line)

    update_lists(nld, deleted_list_attributes)
  end

  def update_lists(nld, attributes)
    destroy_lists(nld)
    create_item_payment_plannings(nld, attributes[:item_payment_plannings]) if attributes[:item_payment_plannings].present?
    create_item_payment_retentions(nld, attributes[:item_payment_retentions]) if attributes[:item_payment_retentions].present?
  end

  def destroy_lists(nld)
    nld.nld_item_payment_plannings.delete_all
    nld.nld_item_payment_retentions.delete_all
  end

  def remove_lists_attributes(attributes)
    {
      item_payment_plannings: attributes.delete(:lista_item_planejamento_pagamento),
      item_payment_retentions: attributes.delete(:lista_item_retencao_pagamento)
    }
  end

  def create_item_payment_plannings(nld, item_payment_plannings)
    list_attributes(item_payment_plannings).each do |attributes|
      nld.nld_item_payment_plannings << Integration::Expenses::NldItemPaymentPlanning.create(attributes)
    end
  end

  def create_item_payment_retentions(nld, item_payment_retentions)
    list_attributes(item_payment_retentions).each do |attributes|
      nld.nld_item_payment_retentions << Integration::Expenses::NldItemPaymentRetention.create(attributes)
    end
  end
end
