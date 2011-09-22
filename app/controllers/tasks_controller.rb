class TasksController < ApplicationController
  before_filter :authenticate

  def new
    @title = "Submit New Request"
    @task = Task.new if signed_in?
  end

  def create
    @task = current_user.tasks.build(params[:task])
    if @task.save
      flash[:success] = "Request Submitted"
      redirect_to 'pages/tasks'
    else
      render 'new'
    end
  end

  def show
    @title = "Comment on a WWCA Request"
    @task = Task.find(params[:id])
  end

  def destroy
  end

  def index
    @tasks = Task.paginate(:page => params[:page])
    @title = "All Requests"
  end


end
