class PlayerFavorite < ActiveRecord::Base
  attr_accessible :player_id, :user_id

  belongs_to :player
  belongs_to :user
end
