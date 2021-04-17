class AddUniquenessConstraintToDateAndUserForReservation < ActiveRecord::Migration[6.1]
  def change
    add_index :reservations, [:user_id, :date], unique: true
  end
end
