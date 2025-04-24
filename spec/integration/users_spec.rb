# spec/integration/api_spec.rb
# rswag:specs:swaggerize
require 'swagger_helper'

RSpec.describe 'API V1', type: :request do
  path '/api/v1/logout' do
    let!(:user) { create(:user, auth_token: 'authen_token') }

    post 'User logout' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header

      response '200', 'successful logout' do
        let(:Authorization) { 'Bearer authen_token' }
        
        run_test!
      end
    end
  end
end
