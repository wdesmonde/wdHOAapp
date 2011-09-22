class Comment < ActiveRecord::Base
  attr_accessible :content

  belongs_to :task
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 500 }
end
