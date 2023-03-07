require 'rails_helper'

describe Integration::Expenses::BudgetBalance::Search do
  it { is_expected.to be_searchable_like('integration_supports_management_units.titulo') }
  it { is_expected.to be_searchable_like('integration_supports_budget_units.titulo') }
  it { is_expected.to be_searchable_like('integration_supports_functions.descricao') }
  it { is_expected.to be_searchable_like('integration_supports_sub_functions.descricao') }
  it { is_expected.to be_searchable_like('integration_supports_government_programs.titulo') }
  it { is_expected.to be_searchable_like('integration_supports_government_actions.titulo') }
  it { is_expected.to be_searchable_like('integration_supports_administrative_regions.titulo') }
  it { is_expected.to be_searchable_like('integration_supports_expense_natures.titulo') }
  it { is_expected.to be_searchable_like('integration_supports_qualified_resource_sources.titulo') }
  it { is_expected.to be_searchable_like('integration_supports_finance_groups.titulo') }
end
