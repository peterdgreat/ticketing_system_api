require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  let(:customer) { create(:user, role: 'customer') }
  let(:agent) { create(:user, :agent) }
  let(:ticket) { create(:ticket, user: customer) }
  let(:customer_token) { Warden::JWTAuth::UserEncoder.new.call(customer, :user, nil).first }
  let(:agent_token) { Warden::JWTAuth::UserEncoder.new.call(agent, :user, nil).first }

  describe 'POST /graphql (addComment)' do
    let(:query) do
      <<~GQL
        mutation {
          addComment(ticketId: "#{ticket.id}", content: "Test comment") {
            id
            content
            user { id }
          }
        }
      GQL
    end

    it 'allows agents to add comments' do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{agent_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['addComment']['content']).to eq('Test comment')
    end

    it 'allows customers to add comments after agent comments' do
      create(:comment, ticket: ticket, user: agent)
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{customer_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['addComment']['content']).to eq('Test comment')
    end

    it 'prevents customers from commenting without agent comments' do
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{customer_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe 'POST /graphql (comments query)' do
    let(:query) do
      <<~GQL
        query {
          comments(ticketId: "#{ticket.id}") {
            id
            content
            user { id }
          }
        }
      GQL
    end

    it 'allows agents to see all comments' do
      create(:comment, ticket: ticket, user: customer)
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{agent_token}" }
      expect(JSON.parse(response.body)['data']['comments'].length).to eq(1)
    end

    it 'allows customers to see comments on their tickets' do
      create(:comment, ticket: ticket, user: agent)
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{customer_token}" }
      expect(JSON.parse(response.body)['data']['comments'].length).to eq(1)
    end
  end
end
