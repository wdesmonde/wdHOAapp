require 'spec_helper'

describe "Tasks" do
  describe "make a new task" do

    before(:each) do
      @user = Factory(:user)
      @content = "the place is sad where we are"
      @priority = "High"
      @status = "New"
      @category = "Landscaping"
      @due_date = (Time.now) + 100000
      integration_sign_in(@user)
    end

    describe "success" do
      it "creates a new task" do
        #get 'tasks/new'
        #response.status.should be(200)
        visit root_path
        response.should have_selector('a', :href => 'tasks/new',
          :content => "Submit a new task")
        # the following line fails with error 'can't find route 'new'
        # click_link "Submit a new task"
        visit 'tasks/new'
        response.should have_selector('title', 
          :content => "WWCA Requests | Submit New Request")
        lambda do
          # response.should render_template('tasks/new')
          fill_in :task_content, :with => @content
          fill_in :task_priority, :with => @priority
          fill_in :task_category, :with => @category
          fill_in :task_due_date_1i, :with => @due_date.year
          fill_in :task_due_date_2i, :with => @due_date.month
          fill_in :task_due_date_3i, :with => @due_date.day
          click_button
          response.should render_template('tasks')
          response.should have_selector('span.content', :content => @content)
        end.should change(Task, :count).by(1)
      end
    end
  end

  describe "show a single task with a varying number of comments" do

    before(:each) do
      @user1 = Factory(:user, :email => "user1@doogma.com")
      @user2 = Factory(:user, :email => "user2@doogma.com")
      @admin = Factory(:user, :email => "admintest@mivhan.net", :admin => true)
      @task1 = Factory(:task, :user_id => @user1.id)
      @content = "the place is sad where we are"
      @priority = "High"
      @status = "New"
      @category = "Landscaping"
      @due_date = (Time.now) + 100000
    end

    it "should show no comments if there are no comments" do
      integration_sign_in(@user1)
      click_link "View all tasks"
    end
    
    it "should show one comment if there is a single comment" do
    end

    it "show two comments" do
    end

    it "has 20 comments" do
    end

    it "has one comment removed, then add another one" do
    end
  end
end
