require 'rails_helper'

RSpec.describe 'Tickets API', type: :request do
  let(:customer) { create(:user, role: 'customer') }
  let(:agent) { create(:user, :agent) }
  let(:customer_token) { Warden::JWTAuth::UserEncoder.new.call(customer, :user, nil).first }
  let(:agent_token) { Warden::JWTAuth::UserEncoder.new.call(agent, :user, nil).first }

  describe 'POST /graphql (createTicket)' do
    let(:query) do
      <<~GQL
        mutation {
          createTicket(title: "Test Ticket", description: "Test Description") {
            id
            title
            status
          }
        }
      GQL
    end

    it 'allows customers to create tickets' do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{customer_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['createTicket']['title']).to eq('Test Ticket')
    end

    it 'prevents agents from creating tickets' do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{agent_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe 'POST /graphql (tickets query)' do
    let(:query) do
      <<~GQL
        query {
          tickets {
            id
            title
            user { id }
          }
        }
      GQL
    end

    it 'allows agents to see all tickets' do
      create(:ticket, user: customer)
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{agent_token}" }
      expect(JSON.parse(response.body)['data']['tickets'].length).to eq(1)
    end

    it 'allows customers to see only their tickets' do
      create(:ticket, user: customer)
      create(:ticket)
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{customer_token}" }
      expect(JSON.parse(response.body)['data']['tickets'].length).to eq(1)
    end
  end
end
