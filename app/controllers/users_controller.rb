class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @title = "New User"
  end

  def login
    @title = "Login"
  end

end
