class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :lane_id
      t.text :player_ids, array: true, default: []
      t.integer :total_no_of_sets
      t.boolean :players_go_one_by_one, default: false
      t.datetime :finished_at
      # t.text :winner_ids, array: true, default: []

      t.timestamps null: false
    end
  end
end
# YOu have 3 keys = [*, ctrl+A, ctrl+c, ctrl+v]. Given n which is number of clicks, find the max number of * s