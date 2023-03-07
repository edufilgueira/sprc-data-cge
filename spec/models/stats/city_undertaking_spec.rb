require 'rails_helper'

describe Stats::CityUndertaking do

  subject(:stats_city_undertaking) { build(:stats_city_undertaking) }

  it_behaves_like 'models/base'
  it_behaves_like 'models/timestamp'

  context 'inheritance' do
    it { is_expected.to be_a(Stat) }
  end
end
