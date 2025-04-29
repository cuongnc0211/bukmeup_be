class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :api

  has_many :availabilities
  has_many :bookings

  def generate_token
    hmac_secret = Rails.application.credentials.config[:hmac_secret]
    payload = { id: id }

    JWT.encode(payload, hmac_secret, 'HS256')
  end
end
