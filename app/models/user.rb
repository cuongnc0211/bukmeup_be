class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :api

  has_many :availabilities
  has_many :bookings

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  has_one_attached :cover do |attachable|
    attachable.variant :thumb, resize_to_limit: [800, 300]
  end

  def generate_token
    hmac_secret = Rails.application.credentials.config[:hmac_secret]
    payload = { id: id }

    JWT.encode(payload, hmac_secret, 'HS256')
  end

  def api_tokens
    Devise::Api::Token.where(resource_owner_type: 'User', resource_owner_id: id)
  end
end
