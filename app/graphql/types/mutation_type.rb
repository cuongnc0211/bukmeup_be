# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_availability, mutation: Mutations::CreateAvailability
    field :create_booking, mutation: Mutations::CreateBooking
  end
end
