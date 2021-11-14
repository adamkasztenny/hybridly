module Types
  class WorkspaceTypeType < Types::BaseEnum
    value "DESKS", "A workspace with desks", value: "desks"
    value "MEETING_ROOM", "A meeting room", value: "meeting_room"
  end

  class WorkspaceType < Types::BaseObject
    field :location, String, null: false
    field :capacity, Integer, null: false
    field :workspace_type, WorkspaceTypeType, null: false
  end
end
