# app/graphql/types/user_type.rb
module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String
    field :last_name, String
    field :phone_number, String
    field :email, String
    field :availabilities, [Types::AvailabilityType], null: true
    field :bookings, [Types::BookingType], null: true
  end
end
