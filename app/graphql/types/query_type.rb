module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :workspaces, [WorkspaceType], null: true do
      description "Returns all workspaces"
    end

    field :reservation_policy, ReservationPolicyType, null: false do
      description "Returns the reservation policy that is currently in effect"
    end

    def workspaces
      Workspace.all
    end

    def reservation_policy
      ReservationPolicy.current
    end
  end
end
