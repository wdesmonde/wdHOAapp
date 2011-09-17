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
    @attr = {
      :name => "Sample Person",
      :email => "sperson@person.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
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

  describe "password validations" do
  
    it "should require a password" do
      User.new(@attr.merge(:password => "",
        :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password_confirmation" do
      User.new(@attr.merge(
        :password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short,
        :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long,
        :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

    describe "password encryption" do
      before(:each) do
        @user = User.create!(@attr)
      end
  
      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end

      it "should set the encrypted password" do
        @user.encrypted_password.should_not be_blank
      end
  
      # to run just tests with a regex char, here, ?, 
      #   the char would have to be escaped
      #   it's silly, then to have a name of a test
      #   with such a char in it.
      describe "has_password? method" do

        it "should be true if the passwords match" do
          @user.has_password?(@attr[:password]).should be_true
        end

        it "should be false if the passwords don't match" do
          @user.has_password?("invalid").should be_false
        end

      end

    describe "authenticate method" do
      
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end

    end  # end authenticate method
    end

  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end # admin attribute

  describe "task associations" do
    before(:each) do
      @user = User.create(@attr)
      @task1 = Factory(:task, :user => @user, :created_at => 1.day.ago)
      @task2 = Factory(:task, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a tasks attribute" do
      @user.should respond_to(:tasks)
    end

    it "should have the right tasks in the right order" do
      @user.tasks.should == [@task2, @task1]
    end

    it "should destroy associated tasks" do
      @user.destroy
      [@task1, @task2].each do |task|
        lambda do
          Task.find(task)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
