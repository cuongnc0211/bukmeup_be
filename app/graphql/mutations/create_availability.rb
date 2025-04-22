# app/graphql/mutations/create_availability.rb
module Mutations
  class CreateAvailability < BaseMutation
    argument :weekday, Integer, required: true
    argument :start_time, String, required: true
    argument :end_time, String, required: true

    type Types::AvailabilityType

    def resolve(weekday:, start_time:, end_time:)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Not authorized" unless user

      user.availabilities.create!(
        weekday: weekday,
        start_time: start_time,
        end_time: end_time
      )
    end
  end
end
