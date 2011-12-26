class Comment < ActiveRecord::Base
  attr_accessible :content

  belongs_to :task
#  has_one :user

  validates :content, :presence => true, :length => { :maximum => 500 }
  validates :task, :presence => true
  validates :user_id, :presence => true
end
