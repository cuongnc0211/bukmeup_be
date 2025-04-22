# app/graphql/types/availability_type.rb
module Types
  class AvailabilityType < Types::BaseObject
    field :id, ID, null: false
    field :weekday, Integer
    field :start_time, String
    field :end_time, String
  end
end
