class Comment < ActiveRecord::Base
  attr_accessible :body, :actor, :user, :commentable

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :actor, :class_name => "Channel"

  validates :body, :presence => true
end
