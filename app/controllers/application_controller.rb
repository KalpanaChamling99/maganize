class ApplicationController < ActionController::Base
  helper_method :current_admin_user, :current_user

  private

  def current_admin_user
    @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id])
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_user_login
    unless current_user
      redirect_to user_login_path, alert: "Please sign in to continue."
    end
  end
end
