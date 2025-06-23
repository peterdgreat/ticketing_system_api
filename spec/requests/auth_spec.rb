require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /auth/sign_in' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    it 'returns a JWT token for valid credentials' do
      user
      post '/auth/sign_in', params: { user: { email: 'test@example.com', password: 'password123' } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['token']).to be_present
    end

    it 'returns error for invalid credentials' do
      user
      post '/auth/sign_in', params: { user: { email: 'test@example.com', password: 'wrong' } }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
    end
  end

  describe 'POST /auth/sign_up' do
    it 'creates a new user and returns a JWT token' do
      post '/auth/sign_up', params: { user: { email: 'new@example.com', password: 'password123', password_confirmation: 'password123', role: 'customer' } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['token']).to be_present
      expect(User.find_by(email: 'new@example.com')).to be_present
    end
  end
end
