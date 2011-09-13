require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
  
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New User")
    end

    it "should have a name field" do
      get 'new'
      response.should have_selector(
        "input[name='user[name]'][type='text']")
    end

    it "should have an email field" do
      get 'new'
      response.should have_selector(
        "input[name='user[email]'][type='text']")
    end

    it "should have a password field" do
      get 'new'
      response.should have_selector(
        "input[name='user[password]'][type='password']")
    end

    it "should have a password_confirmation field" do
      get 'new'
      response.should have_selector(
        "input[name='user[password_confirmation]'][type='password']")
    end
  end
=begin
  describe "GET 'signin'" do
    it "should be successful" do
      get 'signin'
      response.should be_success
    end
  
    it "should have the right title" do
      get 'signin'
      response.should have_selector("title", :content => /Sign in/i)
    end
  end
=end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
          :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign Up New User")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "Misha Hunan", :email => "misha@hu.il",
          :password => "mishuga", :password_confirmation => "mishuga" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      # the assigns method takes a symbol argument and
      #    returns the value of the corresponding instance value
      #    in the controller action
      it "should redirect to the user show page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

    end

  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit User")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url, 
        :content => "Change Image")
    end
  end # get edit

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      describe "where none of the fields are filled in" do

        before(:each) do
          @attr = { :name => "", 
            :email => "", 
            :password => "", :password_confirmation => "" }
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit Settings")
        end
  
      end # blank fields

      describe "where only the name field is filled in" do

        before(:each) do
          @attr = { :name => "Shem Hadash" }
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit Settings")
        end
  
      end # only name field

      describe "where the password field is filled in with an invalid value" do

        before(:each) do
          @attr = { :email => "Shem.Hadash",
            :password => @user.password,
            :password_confirmation => @user.password_confirmation }
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit Settings")
        end
  
      end # invalid email address

    end # put failure

    describe "success" do
      describe "changing all the fields" do

        before(:each) do
          @attr = { :name => "Shona Shem", 
            :email => "shona@shem.net", 
            :password => "newfoolishbar", :password_confirmation => "newfoolishbar" }
        end

        it "should change the user's attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.name.should == @attr[:name]
          @user.email.should == @attr[:email]
          # doesn't test that password was changed
        end

        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/i
        end
      end # changing all fields  

      describe "changing only the name" do

        before(:each) do
          @attr = { :name => "Shona Shem", 
            #:email => "shona@shem.net", 
            :password => "newfoolishbar", :password_confirmation => "newfoolishbar" }
        end

        it "should change the user's name" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.name.should == @attr[:name]
          @user.email.should == @user[:email]
        end

        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/i
        end
      end # changing only name  

      describe "changing only the password" do

        before(:each) do
          @attr = { #:name => "Shona Shem", 
            #:email => "shona@shem.net", 
            :password => "newfoolishbar", :password_confirmation => "newfoolishbar" }
        end

        it "should change the user's password" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.name.should == @user[:name]
          @user.email.should == @user[:email]
        end

        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/i
        end
      end # changing only password  
    end # put success

  end # put update

  describe "authentication of edit/update pages" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do
    
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
    end # non-signed in

    describe "for signed-in users" do
      describe "cannot access another user's edit page" do
        before(:each) do
          wrong_user = Factory(:user, :email => "mistamesh@doogma.net")
          test_sign_in(wrong_user)
        end

        it "should require matching users for 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end

        it "should require matching users for 'update'" do
          put :update, :id => @user
          response.should redirect_to(root_path)
        end
      end # only own edit page
    end # signed in
  end # auth edit/update pages
end
