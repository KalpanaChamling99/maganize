class Admin::UsersController < Admin::BaseController
  before_action -> { require_permission(:manage_users) }
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = AdminUser.includes(:role).with_attached_avatar.order(:name)
  end

  def new
    @user = AdminUser.new
  end

  def create
    @user = AdminUser.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "User \"#{@user.name}\" was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = user_params.reject { |k, v| k == "password" && v.blank? }
    if @user.update(attrs)
      redirect_to admin_users_path, notice: "User \"#{@user.name}\" was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless current_admin_user.can_manage?(@user)
      return redirect_to admin_users_path, status: :see_other, alert: "You cannot delete this user."
    end
    @user.destroy!
    redirect_to admin_users_path, status: :see_other, notice: "User deleted."
  end

  private

  def set_user
    @user = AdminUser.find(params[:id])
  end

  def user_params
    params.require(:admin_user).permit(:name, :email, :password, :role_id, :avatar)
  end
end
