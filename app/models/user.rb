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

require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
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
  validates :password, :presence => true,
    :confirmation => true,
    :length => { :within => 6..40 }
            
  before_save :encrypt_password

  # return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # compare encrypted_password with the encrypted version of
    #    submitted password
    encrypted_password == encrypt(submitted_password)
  end

  # implicitly returns nil if there is a password mismatch
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
