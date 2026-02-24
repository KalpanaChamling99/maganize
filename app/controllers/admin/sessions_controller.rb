class Admin::SessionsController < ApplicationController
  layout "admin_auth"

  def new
    redirect_to admin_root_path if current_admin_user
  end

  def create
    user = AdminUser.authenticate_by_email(params[:email], params[:password])
    if user
      session[:admin_user_id] = user.id
      redirect_to admin_root_path, notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_user_id)
    redirect_to admin_login_path, notice: "You have been signed out."
  end

  private

  def current_admin_user
    @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id])
  end
end
