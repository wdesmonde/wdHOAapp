class Task < ActiveRecord::Base
  attr_accessible :content, :priority, :status, :category, :due_date

  belongs_to :user
  default_scope :order => 'tasks.created_at DESC'
end
