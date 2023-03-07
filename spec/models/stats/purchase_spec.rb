require 'rails_helper'

describe Stats::Purchase do

  subject(:stats_purchase) { build(:stats_purchase) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
