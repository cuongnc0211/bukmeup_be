require 'rails_helper'

RSpec.describe 'Auth Token', type: :request do
  let(:user) { create(:user) }
  let(:valid_token) { user.generate_token }
  let(:invalid_token) { 'invalid_token' }

  describe 'POST /api/v1/logout' do
    context 'when the token is valid' do
      it 'revokes the auth token and returns a success message' do
        # Before logging out, make sure the auth_token is not nil
        user.update(auth_token: valid_token)

        post '/api/v1/logout', params: { auth_token: valid_token }

        user.reload  # Reload to check if the auth_token is nil
        expect(user.auth_token).to be_nil
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['msg']).to eq('Auth token revoked!')
      end
    end

    context 'when the token is invalid' do
      it 'returns an unauthorized error' do
        post '/api/v1/logout', params: { auth_token: invalid_token }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid auth token')
      end
    end

    context 'when no token is provided' do
      it 'returns an unauthorized error' do
        post '/api/v1/logout', params: {}

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid auth token')
      end
    end
  end
end
