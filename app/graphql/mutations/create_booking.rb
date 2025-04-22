# app/graphql/mutations/create_booking.rb
module Mutations
  class CreateBooking < BaseMutation
    argument :user_id, ID, required: true
    argument :client_name, String, required: true
    argument :client_email, String, required: true
    argument :start_time, GraphQL::Types::ISO8601DateTime, required: true
    argument :end_time, GraphQL::Types::ISO8601DateTime, required: true

    type Types::BookingType

    def resolve(**args)
      Booking.create!(args.merge(status: "confirmed"))
    end
  end
end
