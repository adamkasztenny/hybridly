class AddTypeToWorkstations < ActiveRecord::Migration[6.1]
  def change
    add_column :workstations, :workstation_type, :integer
  end
end
