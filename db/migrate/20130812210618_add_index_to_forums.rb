class AddIndexToForums < ActiveRecord::Migration
  def change
    add_index :forums, :team_abbrev
  end
end
