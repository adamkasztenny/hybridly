module Types
  class ReservationType < Types::BaseObject
    field :date, GraphQL::Types::ISO8601Date, null: false
    field :user, String, null: false
    field :workspace, WorkspaceType, null: true
  end
end
