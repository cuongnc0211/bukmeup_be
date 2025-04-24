# spec/integration/api_spec.rb
# rswag:specs:swaggerize
require 'swagger_helper'

RSpec.describe 'API V1', type: :request do
  path '/api/v1/login' do
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

      response '401', 'invalid credentials' do
        let(:payload) { { email: 'wrong@example.com', password: 'wrong' } }

        run_test!
      end
    end
  end
end
