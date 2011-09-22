class Task < ActiveRecord::Base
  attr_accessible :content, :priority, :status, :category, :due_date

  belongs_to :user

  
  def due_date_cannot_be_in_past
    if due_date < Date.today
      errors.add(:due_date, "Due Date can't be in the past")
    end
  end

  validates :content, :presence => true, :length => { :maximum => 500 }
  validates :user_id, :presence => true
  validates :priority, :presence => true, 
    :inclusion => { :in => %w(Emergency High Medium Low) }
  validates :status, :presence => true,
    :inclusion => { :in => (["New", "Approved", "In Progress", "Completed", "Closed"]) }
  validates :category, :presence => true,
    :inclusion => { :in => 
      (["Other", "Major Maintenance", "Minor Maintenance", "Administration", "Landscaping"]) }
  validates :due_date, :presence => true
  validate  :due_date_cannot_be_in_past

  default_scope :order => 'tasks.created_at DESC'
end
