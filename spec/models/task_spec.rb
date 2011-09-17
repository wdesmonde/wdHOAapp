require 'spec_helper'

describe Task do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :content => "sample content for this task",
      :due_date => (Time.now) + (14 * 24 * 60 * 60),
      :status => "New",
      :priority => "High",
      :category => "Other"
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

  describe "validations" do

    it "should require a user id" do
      Task.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.tasks.build(@attr.merge(:content => "   ")).should_not be_valid
    end

    it "should reject overly-long content" do
      @user.tasks.build(@attr.merge(:content => "a" * 501)).should_not be_valid
    end

    it "should accept valid fields" do
      @user.tasks.build(@attr).should be_valid
    end
  
    it "should only accept valid stati" do
      stati = %w(New Approved "In Progress" Completed Closed)
      stati.each do |stati|
        valid_status_task = @user.tasks.build(@attr.merge(:status => stati))
        valid_status_task.should be_valid
      end
    end

    it "should reject an invalid status" do
      @user.tasks.build(@attr.merge(:status => "invalid")).should_not be_valid
    end
    
    it "should only accept valid priorities" do
      priorities = %w(Emergency High Medium Low)
      priorities.each do |priorities|
        @user.tasks.build(@attr.merge(:priority => priorities)).should be_valid
      end
    end

    it "should reject an invalid priority" do
      @user.tasks.build(@attr.merge(:priority => "invalid")).should_not be_valid
    end
    
    it "should only accept valid categories" do
      categories = %w(Administration Other Landscaping "Minor Maintenance" 
        "Major Maintenance")
      categories.each do |categories|
        @user.tasks.build(@attr.merge(:category => categories)).should be_valid
      end
    end

    it "should reject an invalid category" do
      @user.tasks.build(@attr.merge(:category => "invalid")).should_not be_valid
    end
    
    it "should not accept a due date prior to the create date" do
      yesterday = 24 * 60 * 60
      past_due_date_task = @user.tasks.build(@attr.merge(:due_date => Time.now-yesterday))
      past_due_date_task.should_not be_valid
    end

  end
end
