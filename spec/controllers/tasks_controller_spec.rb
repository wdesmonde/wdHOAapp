require 'spec_helper'

describe TasksController do
  render_views

  describe "deny access to anyone not signed in" do
      before(:each) do
        @user = Factory(:user)
        @task = Factory(:task, :user => @user)
      end

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
 
      it "should deny access to 'show'" do
        get :show, :id => 1
        response.should redirect_to(signin_path)
      end

      describe "should deny access to 'destroy' to anyone execpt admins" do

        it "should deny access to 'destroy' for non-signed-in users" do
          delete :destroy, :id => 1
          response.should redirect_to(signin_path)
        end

        # this is duplicated in the DESTROY section
        it "should deny access to 'destroy' for non-admin users" do
          test_sign_in(@user)
          delete :destroy, :id => 1
          response.should redirect_to(tasks_path)
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

      it "should render the new tasks page if create fails" do
        post :create, :task => @attr
        response.should render_template('tasks/new')
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

      it "should redirect to the all tasks page after creation" do
        post :create, :task => @attr
        response.should redirect_to(tasks_path)
      end

      it "should have a flash message" do
        post :create, :task => @attr
        flash[:success].should =~ /request submitted/i
      end

    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = test_sign_in(Factory(:user, :email => Factory.next(:email)))
      @attr =  {
        :content => "A sample request",
        :due_date => Time.now+10000,
        :priority => "High",
        :status => "New",
        :category => "Other"
        }
     @task1 = Factory(:task)
     @tasks = [@task1]
     33.times do
       @tasks << Factory(:task, :user => @user)
      end
    end

    # access control is covered in the access control
    #   part above.  Covers successful cases here.

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector('title', :content => "WWCA Requests | All Requests")
    end

    it "should have an element for each task (request)" do
      get :index
      Task.paginate(:page => 1).each do |task|
        response.should have_selector('a', :content => task.content)
      end
    end

    it "should paginate tasks" do
      get :index
      response.should have_selector('div.pagination')
      response.should have_selector('span.disabled', :content => "Previous")
      response.should have_selector('a', :href => "/tasks?page=2", 
        :content => "2")
      response.should have_selector('a', :href => "/tasks?page=2", 
        :content => "Next")
    end

    it "should have delete links to tasks for admins" do
      @user.toggle!(:admin)
      get :index
      Task.paginate(:page => 1).each do |task|
      # @tasks[0..7].each do |task|
        response.should have_selector('a', :href => task_path(task.id),
          :content => "delete")
      end
    end

    it "should not have delete links to tasks for non-admins" do
      get :index
      @tasks[0..7].each do |task|
        response.should_not have_selector("a", :href => task_path(task),
          :content => "delete")
      end
    end
  end

  describe "DELETE 'destroy'" do
    # access control is covered in the access control
    #   part above.  Covers successful cases here.

    before(:each) do
       @admin = Factory(:user, :admin => true)
       @normal_user = Factory(:user, :email => Factory.next(:email))
       @task1 = Factory(:task, :user => @admin)
       @task2 = Factory(:task, :user => @normal_user)
     end


    it "should destroy a task created by self" do
      test_sign_in(@admin)
      lambda do
        delete :destroy, :id => @task1.id
      end.should change(Task, :count).by(-1)
    end

    it "should destroy a task created by another user" do
      test_sign_in(@admin)
      lambda do
        delete :destroy, :id => @task2.id
      end.should change(Task, :count).by(-1)
    end

    it "should redirect to the all tasks page after destroy" do
      test_sign_in(@admin)
      delete :destroy, :id => @task1.id
      flash[:success].should =~ /deleted/i
      response.should redirect_to(tasks_path)
    end

  end
end
