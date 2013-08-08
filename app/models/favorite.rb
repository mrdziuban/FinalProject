class Favorite < ActiveRecord::Base
  attr_accessible :favoritable_id, :favoritable_type, :user_id

  belongs_to :user
  belongs_to :favoritable, polymorphic: true
  belongs_to :team, foreign_key: :favoritable_id
  belongs_to :player, foreign_key: :favoritable_id
  belongs_to :goalie, foreign_key: :favoritable_id
end