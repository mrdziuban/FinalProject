class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :abbrev
      t.integer :gp
      t.integer :wins
      t.integer :losses
      t.integer :ot_losses
      t.integer :points
      t.float :point_perc
      t.float :gpg
      t.float :gapg
      t.float :pp_perc
      t.float :pk_perc
      t.float :spg
      t.float :sapg
      t.float :faceoff_perc
      t.string :background_color

      t.timestamps
    end
  end
end
