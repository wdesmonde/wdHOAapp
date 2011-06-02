require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New User")
    end
  end

  describe "GET 'login'" do
    it "should be successful" do
      get 'login'
      response.should be_success
    end
  
    it "should have the right title" do
      get 'login'
      response.should have_selector("title", :content => "Login")
    end
  end

end
