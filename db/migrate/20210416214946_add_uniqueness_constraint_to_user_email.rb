class AddUniquenessConstraintToUserEmail < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :email, true
    add_index :users, :email, unique: true
  end
end
