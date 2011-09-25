require 'spec_helper'

describe CommentsController do
  render_views

  before(:each) do
    @admin = Factory(:user, :email => "admin@doogma.net", :admin => true)
    @user1 = Factory(:user, :email => "user1@doogma.net") 
    @task1_admin = Factory(:task, :user => @admin)
    @task2_user = Factory(:task, :user => @user1, :due_date => (Time.now) + 10000)
    @attr_comment1_t1 = { :content => "comment on task", :user_id => @admin.id }
    # @attr_comment2_t2 = { :content => "comment on task", :user_id => @user1.id }
    @attr_comment2_t2 = { :content => "comment on task"  }
    @attr_comment3_t2 = { :content => "another comment on task", :user_id => @user1.id }
  end

  describe "POST 'create'" do

    describe "failure" do

      it "should deny access to 'create' unless signed in" do
        post :create
        response.should redirect_to(signin_path)
      end

    end

    describe "success" do

      it "should create a comment on user's own task" do
        test_sign_in(@user1)
        assigns(:user.id) == @user1.id
        assigns(:task.id) == @task2_user.id
        lambda do
          post :create, :comment => @attr_comment2_t2
        end.should change(Comment, :count).by(1)
      end

      it "should redirect to the show page for the task" do
      end

      it "should show a flash success message" do
      end

      it "should create a comment on admin's own task" do
      end


      it "should create a comment on another user's task" do
      end

      it "should create a second comment on another user's task" do
      end


    end
  

  end

=begin
  no 'new' -- no separate page; will be done on the show single task page
  no 'update' -- no edit action
=end

  describe "DELETE 'destroy'" do

    describe "for non-authorized users" do

      it "should deny access for non-signed-in users" do

      end

      it "should deny access for non-admins" do

      end
    end

    describe "for authorized users (admins only)" do

      it "should destroy the comment" do
      end
     
      it "should redirect to the individual task page" do
      end
     
      it "should show a flash success message" do
      end
     
      
    end
  end

  
end

