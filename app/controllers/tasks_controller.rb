class TasksController < ApplicationController
  before_filter :authenticate
  #before_filter :authorized_user, :only => :destroy

  def new
    @title = "Submit New Request"
    @task = Task.new if signed_in?
  end

  def create
    @task = current_user.tasks.build(params[:task])
    if @task.save
      flash[:success] = "Request Submitted"
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def show
    @title = "Comment on a WWCA Request"
    @task = Task.find(params[:id])
    @comments = Comment.where(:task_id => @task[:id])
    #@new_comment = new_comment_meth
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:success] = "Request Deleted"
    redirect_to tasks_path
  end

  def index
    @tasks = Task.paginate(:page => params[:page])
    @title = "All Requests"
  end

  def comment
    @task.comments.create(params[:comment])
    #Task.find(params[:id]).comments.create(params[:comment])
    flash[:notice] = "Added your comment"
    #redirect_to :action => "show", :id => params[:id]
  end

  private
    def authorized_user
    end

end
