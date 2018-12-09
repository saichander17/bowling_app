class CreateLeaderBoards < ActiveRecord::Migration
  def change
    create_table :leader_boards do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :rank
      t.float :total_score

      t.timestamps null: false
    end
  end
end
