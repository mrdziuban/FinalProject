class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :profile_background

  has_many :team_favorites, class_name: "Favorite", foreign_key: :user_id, conditions: {favoritable_type: "Team"}, dependent: :destroy
  has_many :teams, through: :team_favorites, foreign_key: :favoritable_id

  has_many :player_favorites, class_name: "Favorite", foreign_key: :user_id, conditions: {favoritable_type: "Player"}, dependent: :destroy
  has_many :players, through: :player_favorites, foreign_key: :favoritable_id

  has_many :goalie_favorites, class_name: "Favorite", foreign_key: :user_id, conditions: {favoritable_type: "Goalie"}, dependent: :destroy
  has_many :goalies, through: :goalie_favorites, foreign_key: :favoritable_id, source: :goalie

  has_attached_file :profile_background, styles: {original: "1920x1080>"}

  has_many :analyses

  def to_param
    username
  end

  def favorites
    team_favorites + player_favorites + goalie_favorites
  end
end
