class AddVerifiedByToReservation < ActiveRecord::Migration[6.1]
  def change
    add_reference :reservations, :verified_by, foreign_key: { to_table: :users }, null: true
  end
end
