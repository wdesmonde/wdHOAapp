class CommentsController < ApplicationController
  before_filter :authenticate
  #before_filter :authorized_user, :only => :destroy

#  def new
#    @new_comment = Comment.new
#  end

  def create
    @task = Task.find(params[:task_id])
    # @comment = @task.comments.create!(:content => params[:comment], 
      # :user_id => current_user.id)
    # @comment = @task.comments.build(params[:comment],
    @comment = @task.comments.create(params[:comment])
        # :task_id => (params[:task[:id]]),
        #:task_id => @task,
        #:user_id => current_user.id) 
    if @comment.save
      flash[:success] = "Thanks for your comment!"
      # redirect_to tasks_path
    else
      # show the individual task page again
      # render 'new'
      @task = Task.find(params[:task_id])
      flash[:error] = "Error creating your comment"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment Deleted"
    # redirect_to tasks_path
  end

end
