require 'rails_helper'
require 'jwt'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:valid_token) { user.generate_token }
  let(:invalid_token) { 'invalid_token' }
  let(:hmac_secret) { Rails.application.credentials.config[:hmac_secret] }

  describe '.validate_token' do
    context 'when the token is valid' do
      it 'returns the user' do
        decoded_token = JWT.decode(valid_token, hmac_secret, true, { algorithm: 'HS256' }).first
        decoded_user = User.validate_token(valid_token)
        
        expect(decoded_user).to eq(user)
      end
    end

    context 'when the token is invalid' do
      it 'returns false' do
        expect(User.validate_token(invalid_token)).to eq(false)
      end
    end

    context 'when the token has no id' do
      it 'returns false' do
        invalid_token = JWT.encode({ id: nil }, hmac_secret, 'HS256')
        expect(User.validate_token(invalid_token)).to eq(false)
      end
    end

    context 'when there is a JWT::DecodeError' do
      it 'returns false' do
        allow(JWT).to receive(:decode).and_raise(JWT::DecodeError)
        expect(User.validate_token(invalid_token)).to eq(false)
      end
    end
  end

  describe '#generate_token' do
    it 'generates a token' do
      token = user.generate_token
      decoded_token = JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' }).first

      expect(decoded_token['id']).to eq(user.id)
    end
  end
end
