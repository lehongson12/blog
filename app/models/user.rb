class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  enum role: [:user, :mod, :admin]

	after_initialize :set_default_role, :if => :new_record?
  before_validation :generate_slug

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts

  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_attached_file :avatar, :styles => { :large => "900x300>", :thumb => "64x64>", medium: "250x250" }, :default_url => "/images/:style/missing.png"
  
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  #validates :phone, inclusion: { in: 0..9 } #format: { with: /\d{3}-\d{3}-\d{4}/ || /\d{4}-\d{3}-\d{4}/, message: "Invalid phonenumber" }

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def set_default_role
	  self.role ||= :user
	end

  def should_generate_new_friendly_id?
   new_record? || slug.nil? || slug.blank? # you can add more condition here
  end

	def feed
    #microposts
    #Micropost.where("user_id = ?", id)
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
	def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  private
  def generate_slug
    self.name_slug = name.to_s.parameterize
  end
end
