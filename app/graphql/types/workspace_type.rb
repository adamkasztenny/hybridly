module Types
  class WorkspaceType < Types::BaseObject
    field :id, ID, null: false
    field :location, String, null: true
    field :capacity, Integer, null: true
    field :workspace_type, String, null: true
  end
end