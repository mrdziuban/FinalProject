class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  has_many :team_favorites
  has_many :teams, through: :team_favorites
  has_many :player_favorites
  has_many :players, through: :player_favorites
  has_many :goalie_favorites
  has_many :goalies, through: :goalie_favorites, source: :goalie

  def to_param
    username
  end
end
