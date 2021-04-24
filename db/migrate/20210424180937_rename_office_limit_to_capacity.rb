class RenameOfficeLimitToCapacity < ActiveRecord::Migration[6.1]
  def change
    rename_column :reservation_policies, :office_limit, :capacity
  end
end
