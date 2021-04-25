class RenameWorkstationToWorkspace < ActiveRecord::Migration[6.1]
  def change
    rename_table :workstations, :workspaces
    rename_column :workspaces, :workstation_type, :workspace_type
  end
end
