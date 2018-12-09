class CreateLanes < ActiveRecord::Migration
  def change
    create_table :lanes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
