# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :user, resolver: Resolvers::UserResolver do
      argument :id, ID, required: true, description: "ID of User."
    end
  end
end
