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

    field :reservations_per_day, [ReservationCountType], null: true do
      description "Returns the number of reservations made per day"
    end

    def workspaces
      Workspace.all
    end

    def reservation_policy
      ReservationPolicy.current
    end

    def reservations_per_day
      ReservationService.reservations_per_day.map do |date, number_of_reservations|
        { :date => date, :number_of_reservations => number_of_reservations }
      end
    end
  end
end
