class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  
  belongs_to :follower, :class_name => "User"  # tell rails to check within the "User" class, instead of the "Follower" class
  belongs_to :followed, :class_name => "User"  # points to User.follower_id

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
