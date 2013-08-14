class Comment < ActiveRecord::Base
  attr_accessible :parent_comment_id, :text, :topic_id, :user_id

  belongs_to :topic
  belongs_to :user
  belongs_to :parent_comment, class_name: "Comment", foreign_key: :parent_comment_id
  has_many :child_comments, class_name: "Comment", foreign_key: :parent_comment_id, dependent: :destroy

  validates :text, presence: true
end
