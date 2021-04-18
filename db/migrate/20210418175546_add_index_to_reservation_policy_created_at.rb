class AddIndexToReservationPolicyCreatedAt < ActiveRecord::Migration[6.1]
  def change
    add_index :reservation_policies, :created_at
  end
end
