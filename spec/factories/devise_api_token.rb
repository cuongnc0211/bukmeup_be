FactoryBot.define do
  factory :devise_api_token, class: 'Devise::Api::Token' do
    access_token { 'access_token' }
    refresh_token { 'refresh_token' }
    expires_in { Time.zone.now + 3.days }
    revoked_at { nil }
    previous_refresh_token { '' }
    resource_owner { User.new }
  end
end
