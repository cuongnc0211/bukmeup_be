# spec/integration/api_spec.rb
# rails rswag:specs:swaggerize
require 'swagger_helper'

RSpec.describe 'API V1', type: :request do
  # path '/api/v1/logout' do
  #   let!(:user) { create(:user, auth_token: 'authen_token') }

  #   post 'User logout' do
  #     tags 'Authentication'
  #     consumes 'application/json'
  #     parameter name: 'Authorization', in: :header

  #     response '200', 'successful logout' do
  #       let(:Authorization) { 'Bearer authen_token' }
        
  #       run_test!
  #     end
  #   end
  # end

  path '/api/v1/users/profile' do
    let(:user) { create(:user) }
    let!(:token) { create(:devise_api_token, resource_owner: user, access_token: 'authen_token') }

    get 'get profile' do
      tags 'Get Profile'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header

      response '200', 'successful logout' do
        let(:Authorization) { 'Bearer authen_token' }
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(user.id)
        end
      end
    end
  end
end
