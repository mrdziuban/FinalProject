class Topic < ActiveRecord::Base
  attr_accessible :title, :user_id, :forum_id, :description

  belongs_to :user
  belongs_to :forum
  has_many :comments, dependent: :destroy
  validates :title, presence: true

  def comments_by_parent
    topic_comments = self.comments
    comments_hash = {}
    topic_comment.each do |c|
      comments_hash[c.parent_comment_id] ||= []
      comments_hash[c.parent_comment_id] << comments
    end
    comments_hash
  end
end
