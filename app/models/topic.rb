class Topic < ActiveRecord::Base
  attr_accessible :title, :user_id, :forum_id

  include PgSearch
  pg_search_scope :search_by_title, against: :title

  belongs_to :user
  belongs_to :forum
  validates :title, presence: true

  def to_param
    title.downcase.gsub(" ", "_")[0..35]
  end
end
