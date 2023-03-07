require 'rails_helper'

describe Integration::Supports::RealStates::OccupationType do

  describe 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

end
