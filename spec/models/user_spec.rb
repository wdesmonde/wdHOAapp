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

require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Sample Person", :email => "sperson@person.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  # I removed the length validation, but this long name
  #   should be invalid according to the format rule
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid names" do
    names = ["Joe Schmoe" "Sean O'Casey" "Gustav von Wundermeir" ]
    names << "Abcdeabcdeabcdeabcdea ab Abcdefghijabcdefghijab"
    names << "LeDawn Meade"
    names.each do |name|
      valid_name_user = User.new(@attr.merge(:name => name))
      valid_name_user.should be_valid
    end
  end

  it "should reject invalid names" do
    invalid_names = ["a b" "a" "Abcdefghijklmnopqrstuv Abc"]
    invalid_names.each do |test|
      invalid_name_user = User.new(@attr.merge(:name => test))
      invalid_name_user.should_not be_valid
    end
  end    


  it "should accept valid email addresses" do
    addresses = %w[user@foo.com UPCASE_ULUSER@line.under.org first.last@nonus.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    invalid_addresses = %w[commain@domain,org no_at_sign.net no.top@leveldomain. withoutdot.no@topleveldomain ]
    invalid_addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    upcased_email = @attr[:email].upcase
    # Put a user with a given email address into the database
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

end
