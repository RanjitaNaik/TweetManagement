require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:user) { Fabricate(:user) }
  subject(:tweet) { described_class.new }

  describe 'relationships' do
    it { expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to }
  end

  it 'is valid with all the attributes' do
    tweet.tweet = 'Test'
    tweet.user = user
    tweet.save
    expect(tweet).to be_valid
  end

  it 'is not valid with out attributes' do
    expect(tweet).to_not be_valid
  end
end
