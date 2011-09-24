require 'spec_helper'

describe Comment do

  before(:each) do
    @user = Factory(:user)
    @task = Factory(:task, :user => @user)
    @attr = { :content => "sample comment on a request", :user_id => @user.id }
  end

  it "should create a new comment given valid attributes" do
    @task.comments.create!(@attr)
  end

  describe "user associations" do
    before(:each) do
      @comment1 = @task.comments.create!(@attr)
    end

    it "should have a user attribute" do
      @comment1.should respond_to(:user_id)
    end

    it "should have the right associated user" do
      @comment1[:user_id].should == @user[:id]
    end
  end

  describe "task associations" do

    before(:each) do
      @comment1 = @task.comments.create!(@attr)
    end

    it "should have a tasks attribute" do
      @comment1.should respond_to(:task)
    end
    
  end

  describe "validations" do
    it "should require a user id" do
      # @comment1 = @task.comments.create!(@attr)
      # @comment1.should_not be_valid
      Comment.new(@attr).should_not be_valid
    end

    it "should require a task id" do
      Comment.new(@attr).should_not be_valid
    end

    it "should require non-blank content" do
      @comment1 = @task.comments.build(@attr.merge(:content => "  "))
      @comment1.should_not be_valid
    end

    it "should reject overly-long content" do
      @comment1 = @task.comments.build(@attr.merge(:content => "a" * 501))
      @comment1.should_not be_valid
    end
      
  end

end
