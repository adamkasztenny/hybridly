module Types
  class ReservationPolicyType < Types::BaseObject
    field :capacity, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
