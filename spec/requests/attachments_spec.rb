require 'rails_helper'

RSpec.describe 'Attachments API', type: :request do
  let(:customer) { create(:user, role: 'customer') }
  let(:agent) { create(:user, :agent) }
  let(:ticket) { create(:ticket, user: customer) }
  let(:customer_token) { Warden::JWTAuth::UserEncoder.new.call(customer, :user, nil).first }
  let(:agent_token) { Warden::JWTAuth::UserEncoder.new.call(agent, :user, nil).first }

  describe 'POST /graphql (uploadAttachment)' do
    let(:query) do
      <<~GQL
        mutation($file: Upload!) {
          uploadAttachment(ticketId: "#{ticket.id}", file: $file) {
            id
            fileUrl
            fileName
          }
        }
      GQL
    end

    let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf') }

    let(:operations) do
      {
        query: query,
        variables: { file: nil }
      }
    end

    let(:map) do
      { "0" => ["variables.file"] }
    end

    let(:multipart_params) do
      {
        operations: operations.to_json,
        map: map.to_json,
        "0" => file
      }
    end

    it 'allows agents to upload attachments' do
      post '/graphql', params: multipart_params, headers: { 'Authorization' => "Bearer #{agent_token}" }
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response_body['data']['uploadAttachment']['fileName']).to eq('test.pdf')
    end

    it 'allows customers to upload attachments to their tickets' do
      post '/graphql', params: multipart_params, headers: { 'Authorization' => "Bearer #{customer_token}" }
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response_body['data']['uploadAttachment']['fileName']).to eq('test.pdf')
    end

    it 'prevents customers from uploading to others\' tickets' do
      other_customer = create(:user, role: 'customer')
      other_token = Warden::JWTAuth::UserEncoder.new.call(other_customer, :user, nil).first
      post '/graphql', params: multipart_params, headers: { 'Authorization' => "Bearer #{other_token}" }
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response_body['errors']).to be_present
    end
  end

  describe 'POST /graphql (attachments query)' do
    let(:query) do
      <<~GQL
        query {
          attachments(ticketId: "#{ticket.id}") {
            id
            fileUrl
            user { id }
          }
        }
      GQL
    end

    it 'allows agents to see all attachments' do
      create(:attachment, ticket: ticket, user: customer)
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{agent_token}" }
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response_body['data']['attachments'].length).to eq(1)
    end

    it 'allows customers to see attachments on their tickets' do
      create(:attachment, ticket: ticket, user: agent)
      post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{customer_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['attachments'].length).to eq(1)
    end
  end
end
