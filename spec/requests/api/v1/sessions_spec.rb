require 'rails_helper'

RSpec.describe "POST /api/v1/login", type: :request do
  let(:user) { FactoryBot.create(:user) }

  context 'with valid credentials' do
    it 'returns a JWT token' do
      post '/api/v1/login', params: { email: user.email, password: 'password' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('token')
    end
  end

  context 'with invalid credentials' do
    it 'returns an error message' do
      post '/api/v1/login', params: { email: user.email, password: 'wrongpassword' }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('Invalid credentials')
    end
  end
end