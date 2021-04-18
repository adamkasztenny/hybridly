class CreateReservationPolicies < ActiveRecord::Migration[6.1]
  def change
    create_table :reservation_policies do |t|
      t.integer :office_limit, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
