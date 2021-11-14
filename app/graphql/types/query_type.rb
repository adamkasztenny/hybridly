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

    field :reservations, [ReservationType], null: true do
      description "Returns the reservations made that day"
      argument :date, GraphQL::Types::ISO8601Date, required: true
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

    def reservations(arguments)
      ReservationService.for_date(arguments[:date]).map do |reservation|
        reservation_hash = reservation.as_json
        reservation_hash[:user] = reservation.user.email
        reservation_hash[:workspace] = reservation.workspace.as_json
        reservation_hash
      end
    end
  end
end
