class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_admin

  helper_method :current_admin_user

  private

  def current_admin_user
    @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id])
  end

  def require_admin
    unless current_admin_user
      redirect_to admin_login_path, alert: "Please sign in to access the admin panel."
    end
  end
end
