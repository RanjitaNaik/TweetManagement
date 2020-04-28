require 'rails_helper'

RSpec.describe 'GET /tweets', type: :request do
  let(:url) { '/tweets' }
  let(:user) { Fabricate(:user) }
  let!(:tweet) { Fabricate(:tweet, user: user) }

  context 'when user is not logged in' do
    it 'returns unauthorized' do
      get url
      expect(response).to be_unauthorized
    end
  end

  context 'when user logged in' do
    let(:token) { login_user(user) }
    it 'returns tweets' do
      get url, headers: { "Authorization" => token }
      expect(JSON.parse(response.body).first['tweet']).to eq(tweet.tweet)
    end
  end  

end

RSpec.describe 'GET /tweets/:id', type: :request do
  let(:user) { Fabricate(:user) }
  let(:tweet) { Fabricate(:tweet, user: user) }
  let(:url) { "/tweets/#{tweet.id}" }

  context 'when user is not logged in' do
    it 'returns unauthorized' do
      get url
      expect(response).to be_unauthorized
    end
  end

  context 'when user logged in' do
    let(:token) { login_user(user) }
    it 'returns tweet' do
      get url, headers: { "Authorization" => token }
      expect(JSON.parse(response.body).dig('tweet')).to eq(tweet.tweet)
    end
  end 

  context 'when tweet does not exists' do
    let(:token) { login_user(user) }
    let(:url) { '/tweets/10'}
    it do
      get url, headers: { "Authorization" => token }
      expect(response).to be_not_found
    end
  end 

end

RSpec.describe 'POST /tweets', type: :request do
  let(:url) { '/tweets' }
  let(:user) { Fabricate(:user) }

  context 'when user is not logged in' do
    it 'returns unauthorized' do
      post url
      expect(response).to be_unauthorized
    end
  end

  context 'when user logged in' do
    let(:token) { login_user(user) }
    let(:tweet_params) { { tweet: { tweet: 'How are you' } } }

    it 'allows user to tweet' do
      post url, headers: { "Authorization" => token }, params: tweet_params
      expect(JSON.parse(response.body).dig('tweet')).to eq('How are you')
      expect(JSON.parse(response.body).dig('user_id')).to eq user.id
    end
  end  

end

RSpec.describe 'PUT /tweets/:id', type: :request do
  let(:user) { Fabricate(:user) }
  let(:tweet) { Fabricate(:tweet, user: user) }
  let(:url) { "/tweets/#{tweet.id}" }

  context 'when user is not logged in' do
    it 'returns unauthorized' do
      put url
      expect(response).to be_unauthorized
    end
  end

  context 'when author is updating' do
    let(:token) { login_user(user) }
    let(:tweet_params) { { tweet: { tweet: 'This is updated' } } }

    it 'allows user to update tweet' do
      put url, headers: { "Authorization" => token }, params: tweet_params
      expect(JSON.parse(response.body).dig('tweet')).to eq('This is updated')
    end
  end  

  context 'when a non author user is updating' do
    let(:tweet_params) { { tweet: { tweet: 'This is updated' } } }
    let(:non_author) { Fabricate(:user, email: 'Test123@text.com') }
    let(:non_author_token) { login_user(non_author) }

    it 'returns forbidden ' do
      put url, headers: { "Authorization" => non_author_token }, params: tweet_params
      expect(response).to be_forbidden
    end
  end

  context 'when an admin user is updating' do
    let(:tweet_params) { { tweet: { tweet: 'This is admin updated' } } }
    let(:admin) { Fabricate(:user, email: 'admin@text.com') }
    let(:admin_token) { login_user(admin) }
    
    it 'allows admin to update the tweet' do
      admin.add_role(:admin)
      put url, headers: { "Authorization" => admin_token }, params: tweet_params
      expect(JSON.parse(response.body).dig('tweet')).to eq('This is admin updated')
    end
  end
end

RSpec.describe 'DELETE /tweets/:id', type: :request do
  let(:user) { Fabricate(:user) }
  let!(:tweet) { Fabricate(:tweet, user: user) }
  let!(:another_tweet) { Fabricate(:tweet, user: user) }
  let(:url) { "/tweets/#{tweet.id}" }

  context 'when user is not logged in' do
    it 'returns unauthorized' do
      delete url
      expect(response).to be_unauthorized
    end
  end

  context 'when author is deleting' do
    let(:token) { login_user(user) }
    it 'allows user to delete tweet' do
      delete url, headers: { "Authorization" => token }
      expect(JSON.parse(response.body)['message']).to eq('Deleted successfully')
    end
  end  

  context 'when a non author user is deleting' do
    let(:non_author) { Fabricate(:user, email: 'Test123@text.com') }
    let(:non_author_token) { login_user(non_author) }
    let(:url) { "/tweets/#{another_tweet.id}" }

    it 'returns forbidden ' do
      delete url, headers: { "Authorization" => non_author_token }
      expect(response).to be_forbidden
    end
  end

  context 'when an admin user is deleting' do
    let(:admin) { Fabricate(:user, email: 'admin@text.com') }
    let(:admin_token) { login_user(admin) }
    let(:url) { "/tweets/#{another_tweet.id}" }

    it 'allows admin to delete the tweet' do
      admin.add_role(:admin)
      delete url, headers: { "Authorization" => admin_token }
      expect(JSON.parse(response.body)['message']).to eq('Deleted successfully')
      expect(response).to be_ok
    end
  end
end