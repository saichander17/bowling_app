class CreateGameSets < ActiveRecord::Migration
  def change
    create_table :game_sets do |t|
      t.string :name
      t.integer :plays
      t.integer :game_id
      t.integer :player_id
      t.text :pins_dropped, array: true, default: []
      t.text :extra_chance_pins_dropped, array: true, default: []
      t.integer :set_number
      t.integer :no_of_pins
      t.float :strike_bonus
      t.float :spare_bonus
      t.float :score_per_pin
      t.float :bonus_score
      t.integer :extra_chances_for_spare
      t.integer :extra_chances_for_strike



      t.timestamps null: false
    end
  end
end

