require 'rails_helper'
require 'jwt'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:valid_token) { user.generate_token }
  let(:invalid_token) { 'invalid_token' }
  let(:hmac_secret) { Rails.application.credentials.config[:hmac_secret] }

  describe '#generate_token' do
    it 'generates a token' do
      token = user.generate_token
      decoded_token = JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' }).first

      expect(decoded_token['id']).to eq(user.id)
    end
  end
end
