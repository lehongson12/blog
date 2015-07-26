class Post < ActiveRecord::Base
	belongs_to :user

  validates :title,  presence: true
  validates :description, presence: true
  #validates :link
  has_attached_file :image, styles: { medium: "700x500#", small: "350x250#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
