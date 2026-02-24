class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_login

  helper_method :current_admin_user

  private

  def current_admin_user
    @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id])
  end

  def require_login
    unless current_admin_user
      redirect_to admin_login_path, alert: "Please sign in to access the admin panel."
    end
  end

  # Role-based authorization helpers — used as before_action in child controllers
  def require_role(minimum_role)
    unless current_admin_user&.at_least?(minimum_role)
      redirect_to admin_root_path, alert: "You don't have permission to do that."
    end
  end

  def require_author_role
    require_role(:author)
  end

  def require_editor_role
    require_role(:editor)
  end

  def require_admin_role
    require_role(:admin)
  end

  def require_root_admin
    require_role(:root_admin)
  end
end
