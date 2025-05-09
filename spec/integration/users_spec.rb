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

  path '/api/v1/users/3' do
    put 'Update current user profile' do
      tags 'Users APIs'
      consumes 'multipart/form-data'
      produces 'application/json'
  
      parameter name: 'Authorization', in: :header, type: :string, required: true
  
      parameter name: :first_name, in: :formData, type: :string, required: false
      parameter name: :last_name, in: :formData, type: :string, required: false
      parameter name: :phone_number, in: :formData, type: :string, required: false
      parameter name: :avatar, in: :formData, type: :file, required: false
      parameter name: :cover, in: :formData, type: :file, required: false
  
      response '200', 'user updated successfully' do
        let(:Authorization) { 'Bearer authen_token' }
        let!(:user) { create(:user) }
        let!(:token) { create(:devise_api_token, resource_owner: user, access_token: 'authen_token') }
  
        # Sample update data (if not testing file upload, you can omit avatar/cover)
        let(:first_name) { 'John' }
        let(:last_name) { 'Doe' }
        let(:phone_number) { '0123456789' }
        let(:cover) { nil }
  
        # Add sample response from UserBlueprint manually
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 email: { type: :string },
                 full_name: { type: :string },
                 phone_number: { type: :string },
                 avatar_url: { type: :string, nullable: true },
                 cover_url: { type: :string, nullable: true }
               }
  
        example 'application/json', 'user profile updated', {
          id: 1,
          email: 'john.doe@example.com',
          first_name: 'John',
          last_name: 'Doe',
          phone_number: '0355xxxyyy',
          avatar_url: 'https://bukmeup.com/rails/active_storage/blobs/.../avatar.jpg',
          cover_url: 'https://bukmeup.com/rails/active_storage/blobs/.../cover.jpg'
        }

        run_test!
      end
  
      response '401', 'unauthorized' do
        let(:Authorization) { nil }
  
        schema type: :object,
               properties: {
                 error: { type: :string }
               }
  
        example 'application/json', 'unauthorized', {
          error: 'Unauthorized'
        }
  
        run_test!
      end
    end
  end
end
