class AddVerificationCodeToReservation < ActiveRecord::Migration[6.1]
  def change
    add_column :reservations, :verification_code, :string, unique: true, null: false
  end
end
