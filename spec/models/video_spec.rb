require 'rails_helper'

RSpec.describe Video, type: :model do
  subject { build(:video) }

  # FactoryGirl
  describe 'FactoryBot' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:video)).to be_valid
    end
  end
end