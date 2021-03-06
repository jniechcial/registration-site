class UsersController < ApplicationController
	before_action :signed_in_user, only: [:edit, :update]
	before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

	def show
    @user = User.find(params[:id])
  end
  
  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params_for_create)
    if @user.save
    	sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params_for_update)
      flash[:success] = "Profile updated"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to admins_users_path
  end

  private

    def user_params_for_create
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :city, :tshirt, :agreement, :terms)
    end

    def user_params_for_update
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :city, :tshirt)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
