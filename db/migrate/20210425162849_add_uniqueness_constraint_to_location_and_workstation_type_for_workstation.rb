class AddUniquenessConstraintToLocationAndWorkstationTypeForWorkstation < ActiveRecord::Migration[6.1]
  def change
    add_index :workstations, [:location, :workstation_type], unique: true
  end
end
