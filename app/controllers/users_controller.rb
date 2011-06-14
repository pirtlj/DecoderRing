class UsersController < ApplicationController
  def index
    @users = User.all  
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def avatar
    @user = User.find(params[:id])
    
    redirect_to @user.fb_avatar
  end
end
