class Forum < ActiveRecord::Base
  attr_accessible :title, :team_abbrev

  belongs_to :team, foreign_key: :team_abbrev, primary_key: :abbrev
end
