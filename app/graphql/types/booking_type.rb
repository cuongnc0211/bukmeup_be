# app/graphql/types/booking_type.rb
module Types
  class BookingType < Types::BaseObject
    field :id, ID, null: false
    field :client_name, String
    field :client_email, String
    field :start_time, GraphQL::Types::ISO8601DateTime
    field :end_time, GraphQL::Types::ISO8601DateTime
    field :status, String
  end
end
