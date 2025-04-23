class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :availabilities
  has_many :bookings

  def self.validate_token(token)
    hmac_secret = Rails.application.credentials.config[:hmac_secret]

    decoded_token = JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' })&.first
    return false if decoded_token.blank? || decoded_token['id'].blank?

    User.find_by(id: decoded_token['id'])
  rescue JWT::DecodeError
    return false
  end

  def generate_token
    hmac_secret = Rails.application.credentials.config[:hmac_secret]
    payload = { id: id }

    JWT.encode(payload, hmac_secret, 'HS256')
  end
end
