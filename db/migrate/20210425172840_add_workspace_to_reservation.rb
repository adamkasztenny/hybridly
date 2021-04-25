class AddWorkspaceToReservation < ActiveRecord::Migration[6.1]
  def change
    add_reference :reservations, :workspace, foreign_key: true
  end
end
