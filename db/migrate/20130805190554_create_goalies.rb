class CreateGoalies < ActiveRecord::Migration
  def change
    create_table :goalies do |t|
      t.string :name
      t.integer :age
      t.string :team_abbrev
      t.integer :gp
      t.integer :w
      t.integer :l
      t.integer :otl
      t.integer :ga
      t.integer :sa
      t.integer :sv
      t.float :sv_perc
      t.float :gaa
      t.integer :shutouts
      t.integer :min

      t.timestamps
    end
  end
end
