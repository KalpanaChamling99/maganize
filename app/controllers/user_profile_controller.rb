class UserProfileController < ApplicationController
  before_action :require_user_login

  def edit
  end

  def update
    attrs = profile_params.reject { |k, v| k == "password" && v.blank? }
    if current_user.update(attrs)
      redirect_to user_profile_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :password, :password_confirmation, :avatar)
  end
end
