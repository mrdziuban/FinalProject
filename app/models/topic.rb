class Topic < ActiveRecord::Base
  attr_accessible :title, :user_id, :forum_id, :description

  belongs_to :user
  belongs_to :forum
  has_many :comments
  validates :title, presence: true
end
