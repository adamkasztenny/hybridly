class CreateWorkstations < ActiveRecord::Migration[6.1]
  def change
    create_table :workstations do |t|
      t.string :location
      t.integer :capacity
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
