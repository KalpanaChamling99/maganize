class ApplicationController < ActionController::Base
  helper_method :current_admin_user

  private

  def current_admin_user
    @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id])
  end
end
