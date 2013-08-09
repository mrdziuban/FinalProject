class UsersController < ApplicationController
  before_filter :authenticate_user!, except: :new

  def show
    @user = User.find_by_username(params[:id])
  end

  def update
    @user = User.find_by_username(params[:id])
    @user.update_attributes(params[:user])
    redirect_to user_url(@user)
  end
end