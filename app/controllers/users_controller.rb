class UsersController < ApplicationController
  layout "admin_auth"

  def new
    redirect_to user_profile_path if current_user
    @user = User.new
  end

  def create
    @user = User.new(signup_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_profile_path, notice: "Welcome, #{@user.name}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def signup_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
