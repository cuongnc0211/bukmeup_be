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
        let(:user) { create(:user, confirmed_at: 10.minutes.ago) }
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

  path '/users/tokens/sign_up' do
    post 'User signup' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: 'payload', in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string },
          phone_number: { type: :string },
        },
        required: [ 'email', 'password', 'first_name', 'last_name' ]
      }

      response '201', 'successful signup' do
        let(:payload) do
          {
            email: 'user_rspec@example.com',
            password: 'password',
            first_name: 'Cuong',
            last_name: 'Nguyen',
            phone_number: '+84255619678',
          }          
        end

        run_test! do |response|
          res = JSON.parse(response.body)

          expect(res).to include('token')
          expect(res['resource_owner']['email']).to eq(payload[:email])
        end
      end

      response '422', 'Record Invalid' do
        let(:payload) do
          {
            email: 'user_rspec@example.com',
            password: '',
            first_name: 'Cuong',
            last_name: 'Nguyen',
          }
        end

        run_test! do |response|
          res = JSON.parse(response.body)

          expect(response.body.include?("Password can't be blank")).to be(true)
          expect(res).to include('error')
        end
      end
    end
  end
end
