class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :team_abbrev
      t.integer :gp
      t.integer :g
      t.integer :a
      t.integer :blocks
      t.integer :pts
      t.integer :plus_minus
      t.integer :pim
      t.integer :ppg
      t.integer :shots
      t.float :shot_perc
      t.float :fo_perc
      t.integer :hits

      t.timestamps
    end
  end
end
