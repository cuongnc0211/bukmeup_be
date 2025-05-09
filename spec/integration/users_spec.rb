# spec/integration/api_spec.rb
# rails rswag:specs:swaggerize
require 'swagger_helper'

RSpec.describe 'API V1', type: :request do
  

  path '/api/v1/users/profile' do
    get 'get profile' do
      tags 'Users APIs'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header

      response '200', 'successful logout' do
        let(:Authorization) { 'Bearer authen_token' }
        let!(:user) { create(:user) }
        let!(:token) { create(:devise_api_token, resource_owner: user, access_token: 'authen_token') }
        let(:response_example) { JSON.parse(UserBlueprint.render(user).to_json) }

        example 'application/json', 'sample', {
          id: 123,
          email: 'demo@example.com',
          first_name: 'Cuong',
          last_name: 'Nguyen',
          phone_number: '0355xxxyyy',
        }


        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(user.id)
        end
      end
    end
  end

  path '/api/v1/users/confirm_email' do
    post 'confirm success' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header
      parameter name: :confirmation_token, in: :body, schema: {
        type: :object,
        properties: {
          confirmation_token: { type: :string }
        },
        required: ['confirmation_token']
      }

      before do
        user.update(confirmation_token: 'valid_token', confirmation_sent_at: Time.zone.now)
      end

      response '200', 'ok' do
        let(:Authorization) { 'Bearer authen_token' }
        let(:confirmation_token) { { confirmation_token: 'valid_token' } }
        let!(:user) { create(:user) }
        let!(:token) { create(:devise_api_token, resource_owner: user, access_token: 'authen_token') }
        
        run_test!
      end
    end
  end
end
