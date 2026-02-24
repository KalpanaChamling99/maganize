class Admin::ProfilesController < Admin::BaseController
  def show
  end

  def update
    attrs = profile_params.reject { |k, v| k == "password" && v.blank? }
    if current_admin_user.update(attrs)
      redirect_to admin_profile_path, notice: "Profile updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:admin_user).permit(:name, :email, :password, :avatar)
  end
end
