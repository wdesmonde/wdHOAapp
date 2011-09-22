require 'spec_helper'

describe Comment do

  before(:each) do
    @user = Factory(:user)
    @task = Factory(:task, :user => @user)
    @attr = { :content => "sample comment on a request", :user => @user }
  end

  it "should create a new comment given valid attributes" do
    @task.comments.create!(@attr)
  end

end
