require 'spec_helper'

describe Task do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :content => "sample content for this task",
      :due_date => (Time.now) + (14 * 24 * 60 * 60),
      :status => "New",
      :priority => "Medium",
      :catetory => "Minor Maintenance"
      }
  end

  it "should create a new instance given valid attributes" do
    @user.tasks.create!(@attr)
  end

  describe "user associations" do
    before(:each) do
      @task = @user.tasks.create(@attr)
    end

    it "should have a user attribute" do
      @task.should respond_to(:user)
    end

    it "should have the right associated user" do
      @task.user_id.should == @user.id
      @task.user.should == @user
    end
  end

  describe "task associations" do
    before(:each) do
      @user = User.create(@attr)
    end

    it "should have a tasks attribute" do
      @user.should respond_to(:tasks)
    end
  end
end
