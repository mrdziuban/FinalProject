class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :title
      t.string :team_abbrev

      t.timestamps
    end
  end
end
