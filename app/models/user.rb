# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :name, :email
  # names have to consist of two or three alphabetical words
  #   first name and last name must begin with an uppercase letter
  #   can have a two-part name (e.g., von)
  #   can have an apostrophe in last name
  #   Valid examples:  Joe Schmoe, Sean O'Malley, Gustav von Trapp,
  #     LeDawn Meade
  name_regex = %r{([A-Z][a-z]{1,20})\s(([A-Z][a-z'][A-Za-z]{1,20})|([a-z]{2,4})\s([A-Z][a-z'][A-Za-z]{1,20}))}
  # using email validation regex from Rubular
  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :name, :presence => true,
    #:length => { :maximum => 50 },
    :format => { :with => name_regex }
  validates :email, :presence => true,
    :format => { :with => email_regex },
    :uniqueness => { :case_sensitive => false }
            
end
