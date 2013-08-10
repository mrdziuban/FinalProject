class Analysis < ActiveRecord::Base
  attr_accessible :title, :user_id, :pdf
  has_attached_file :pdf
  validates_attachment_content_type :pdf, content_type: ["application/pdf"]

  belongs_to :user
end
