module Types
  class ReservationCountType < Types::BaseObject
    field :date, GraphQL::Types::ISO8601Date, null: false
    field :number_of_reservations, Integer, null: false
  end
end
