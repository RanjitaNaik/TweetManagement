require 'rails_helper'

RSpec.describe TweetSerializer, type: :serializer do

  let(:user) { Fabricate(:user) }
  let(:tweet) { Fabricate(:tweet, user: user) }

  let(:expected_keys) do

    %i[id tweet user_id]

  end

  describe '#attributes' do

    it do
      expect(described_class.new(tweet).attributes.to_h.keys.sort).to eq(expected_keys.sort)
    end

    it do
      expect(tweet.user_id).to eq user.id
    end
  end
end