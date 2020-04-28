require 'rails_helper'

RSpec.describe 'Password Reset', type: :request do
  let!(:user) { Fabricate(:user) }

  describe 'POST password/forgot' do

    it 'returns status code 200 with user found' do
      post password_forgot_path, params: {email: user.email}
      expect(response).to have_http_status(200)
    end

    it 'returns status code 404 with no user found' do
      post password_forgot_path, params: {email: 'not#anemail.com'}
      expect(response).to have_http_status(404)
    end

    it 'generates password_reset_token' do
      expect { post password_forgot_path, params: {email: user.email} }.to change { user.reload.reset_password_token }
    end

  end

  describe 'POST password/reset' do
    let(:token) do 
      user.generate_password_token! 
      user.reload.reset_password_token
    end
    it 'returns status code 200 with token found' do
      post password_reset_path, params: {token: token}
      expect(response).to have_http_status(200)
    end

    it 'resets password' do
      post password_reset_path, params: {password: 'password', token: token}
      expect(response).to have_http_status(200)
      expect(user.reload.reset_password_token).to eq nil  
    end


  end

end
