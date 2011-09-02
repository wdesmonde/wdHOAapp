class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign Up New User"
  end

  def login
    @title = "Login"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the WWCA Requests Site"
      redirect_to @user
    else
      @title = "Sign Up New User"
      render 'new'
    end
  end


end
