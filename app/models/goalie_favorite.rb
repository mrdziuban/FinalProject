class GoalieFavorite < ActiveRecord::Base
  attr_accessible :goalie_id, :user_id

  belongs_to :goalie
  belongs_to :user
end
