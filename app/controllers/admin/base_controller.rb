class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_login

  helper_method :current_admin_user

  private

  def current_admin_user
    @current_admin_user ||= AdminUser.includes(:role).find_by(id: session[:admin_user_id])
  end

  def require_login
    unless current_admin_user
      redirect_to admin_login_path, alert: "Please sign in to access the admin panel."
    end
  end

  def require_permission(permission)
    unless current_admin_user&.can?(permission)
      redirect_to admin_root_path, alert: "You don't have permission to do that."
    end
  end
end
