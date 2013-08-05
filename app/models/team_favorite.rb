class TeamFavorite < ActiveRecord::Base
  attr_accessible :team_abbrev, :user_id

  belongs_to :team, foreign_key: "team_abbrev", primary_key: "abbrev"
  belongs_to :user
end
