module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :workspaces, [WorkspaceType], null: true do
      description "Return all workspaces"
    end

    def workspaces
      Workspace.all
    end
  end
end
