class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :visibility, null: false, default: "Private"
      t.string :status, null: false, default: "Not Started"
      t.date :due_date
      t.integer :user_id, null: false

      t.timestamps null: false
    end

    add_index :goals, :user_id
  end
end
