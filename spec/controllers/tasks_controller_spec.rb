require 'spec_helper'

describe TasksController do
  render_views

  describe "deny access to anyone not signed in" do

      it "should deny access to 'new'" do
        get 'new'
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'create'" do
        post :create
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'index'" do
        get :index
        response.should redirect_to(signin_path)
      end
 
      describe "should deny access to 'destroy' to anyone execpt admins" do

        it "should deny access to 'destroy' for non-signed-in users" do
          delete :destroy, :id => 1
          response.should redirect_to(signin_path)
        end

        it "should deny access to 'destroy' for non-admin users" do
          #TODO
        end

      end
     
  end

  describe "GET 'new'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Submit New Request")
    end

  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do
      before(:each) do
        @attr =  {
          :content => "",
          :due_date => Time.now+10000,
          :priority => "High",
          :status => "New",
          :category => "Other"
        }
      end

      it "should not create a task" do
        lambda do
          post :create, :task => @attr
        end.should_not change(Task, :count)
      end

      it "should render the home page" do
        post :create, :task => @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do
  
      before(:each) do
        @attr =  {
          :content => "A sample request",
          :due_date => Time.now+10000,
          :priority => "High",
          :status => "New",
          :category => "Other"
        }
      end

      it "should create a task" do
        lambda do
          post :create, :task => @attr
        end.should change(Task, :count).by(1)
      end

      it "should redirect to the home page after creation" do
        post :create, :task => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :task => @attr
        flash[:success].should =~ /request submitted/i
      end

    end
  end

  describe "GET 'index'" do
    # TODO
    # access control is covered in the access control
    #   part above.  Covers successful cases here.
  end

  describe "DELETE 'destroy'" do
    # TODO
    # access control is covered in the access control
    #   part above.  Covers successful cases here.
  end
end
