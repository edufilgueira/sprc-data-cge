require 'rails_helper'

describe Stats::RealState do

  subject(:stats_real_state) { build(:stats_real_state) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
