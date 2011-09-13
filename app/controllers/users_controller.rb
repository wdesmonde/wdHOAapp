class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @title = "All Members"
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign Up New User"
  end

  def signin
    @title = "Sign in"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the WWCA Requests Site"
      redirect_to @user
    else
      @title = "Sign Up New User"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    # this line is now part of 'correct_user'
    # @user = User.find(params[:id])
    @title = "Edit Settings"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      @title = "Edit Settings"
      render 'edit'
    end
  end

  private
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
