class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, :admin_user

  def index
    @users = User.paginate page: params[:page], per_page: 10
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find params[:id]
  end

  def create
    @user = User.new user_params
    if @user.save      
      flash[:success] = "Created new user"
      redirect_to admin_users_url
    else
      flash[:success] = "Error"
      render 'new'
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      if current_user == @user
        flash[:success] = 'Profile updated'      
        redirect_to [:admin, @user]
      else
        flash[:success] = 'Information changed'      
        redirect_to admin_users_url
      end
    else
      flash[:success] = "Error"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to admin_users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password, :admin, :avatar
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = 'Please log in by admin account.'
      redirect_to root_url
    end   
  end
end
