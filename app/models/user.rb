class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  has_many :favorites
  has_many :teams, through: :favorites, class_name: "Team", foreign_key: :favoritable_id
  has_many :players, through: :favorites, class_name: "Player", foreign_key: :favoritable_id
  has_many :goalies, through: :favorites, class_name: "Goalie", foreign_key: :favoritable_id

  def to_param
    username
  end
end
