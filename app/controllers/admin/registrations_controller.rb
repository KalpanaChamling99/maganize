class Admin::RegistrationsController < Admin::BaseController
  before_action -> { require_permission(:manage_users) }

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.new(registration_params)
    if @admin_user.save
      redirect_to admin_users_path, notice: "User \"#{@admin_user.name}\" was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:admin_user).permit(:name, :email, :password, :password_confirmation)
  end
end
