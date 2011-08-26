class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @title = "New User"
  end

  def login
    @title = "Login"
  end

end
