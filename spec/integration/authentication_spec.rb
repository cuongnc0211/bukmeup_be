# spec/integration/api_spec.rb
# rails rswag:specs:swaggerize
require 'swagger_helper'

RSpec.describe 'API V1', type: :request do
  path '/users/tokens/sign_in' do
    post 'User login' do
      tags 'Authentication'
      consumes 'application/json'

      parameter name: 'payload', in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'successful login' do
        let(:user) { create(:user) }
        let(:payload) { {email: user.email, password: 'password'} }
        
        run_test!
      end

      response '400', 'invalid credentials' do
        let(:payload) { { email: 'wrong@example.com', password: 'wrong' } }

        run_test!
      end
    end
  end

  path '/users/tokens/revoke' do
    let!(:user) { create(:user) }
    let!(:token) { create(:devise_api_token, resource_owner: user, access_token: 'authen_token') }

    post 'User logout' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header

      response '204', 'successful logout' do
        let(:Authorization) { 'Bearer authen_token' }
        
        run_test!
      end
    end
  end
end
