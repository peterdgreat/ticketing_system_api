require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /graphql (signUp)' do
    let(:query) do
      <<~GQL
        mutation($email: String!, $password: String!, $role: String!) {
          signUp(email: $email, password: $password, role: $role) {
            token
            user {
              id
              email
              role
            }
          }
        }
      GQL
    end

    it 'creates a customer user' do
      post '/graphql', params: { query: query, variables: { email: 'customer@example.com', password: 'password123', role: 'customer' } }
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response_body['data']['signUp']['user']['email']).to eq('customer@example.com')
      expect(response_body['data']['signUp']['user']['role']).to eq('customer')
      expect(response_body['data']['signUp']['token']).to be_present
    end

    it 'creates an agent user' do
      post '/graphql', params: { query: query, variables: { email: 'agent@example.com', password: 'password123', role: 'agent' } }
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response_body['data']['signUp']['user']['email']).to eq('agent@example.com')
      expect(response_body['data']['signUp']['user']['role']).to eq('agent')
      expect(response_body['data']['signUp']['token']).to be_present
    end

    #come back here
    # it 'fails with invalid role' do
    #   post '/graphql', params: {
    #     query: query,
    #     variables: { email: 'peterdgreat2016@gmail.com', password: 'Passsword123', role: 'invalid' }
    #   }
    #   response_body = JSON.parse(response.body)
    #   # expect(response).to have_http_status(:ok)
    #   expect(response_body['errors']).to be_present
    #   # expect(response_body['errors'].first['message']).to include('invalid is not a valid role')
    #   expect(response_body['data']['signUp']).to be_nil
    # end
  end

  describe 'POST /graphql (login)' do
    let(:query) do
      <<~GQL
        mutation($email: String!, $password: String!) {
          login(email: $email, password: $password) {
            token
            user {
              id
              email
              role
            }
          }
        }
      GQL
    end

    let(:user) { create(:user, email: 'user@example.com', password: 'password123', role: 'customer') }

    it 'logs in a user with valid credentials' do
      user
      post '/graphql', params: { query: query, variables: { email: 'user@example.com', password: 'password123' } }
      response_body = JSON.parse(response.body)
      puts ("response.body login" + response.body)
      expect(response).to have_http_status(:ok)
      expect(response_body['data']['login']['user']['email']).to eq('user@example.com')
      expect(response_body['data']['login']['token']).to be_present
    end

    it 'fails with invalid credentials' do
      user
      post '/graphql', params: { query: query, variables: { email: 'user@example.com', password: 'wrong' } }
      response_body = JSON.parse(response.body)
      puts ("response.body invalid" + response.body)
      expect(response).to have_http_status(:ok)
      expect(response_body['errors']).to be_present
      expect(response_body['errors'].first['message']).to eq('Invalid email or password')
    end
  end
end
