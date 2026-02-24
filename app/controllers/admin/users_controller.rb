class Admin::UsersController < Admin::BaseController
  before_action :require_admin_role
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = if current_admin_user.root_admin?
      AdminUser.order(:name)
    else
      AdminUser.where.not(role: AdminUser.roles[:root_admin]).order(:name)
    end
  end

  def new
    @user = AdminUser.new
  end

  def create
    @user = AdminUser.new(user_params)
    if safe_role_assignment(@user) && @user.save
      redirect_to admin_users_path, notice: "User \"#{@user.name}\" was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    safe_role_assignment(@user)
    attrs = user_params.reject { |k, v| k == "password" && v.blank? }
    if @user.update(attrs)
      redirect_to admin_users_path, notice: "User \"#{@user.name}\" was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless current_admin_user.can_manage?(@user)
      return redirect_to admin_users_path, alert: "You cannot delete this user."
    end
    @user.destroy!
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def set_user
    @user = AdminUser.find(params[:id])
    unless current_admin_user.root_admin? || !@user.at_least?(:admin)
      redirect_to admin_users_path, alert: "You don't have permission to manage this user."
    end
  end

  # Ensure the assigned role is not higher than the current user's own role
  def safe_role_assignment(user)
    requested = params.dig(:admin_user, :role).to_s
    return true if requested.blank?
    if AdminUser.roles[requested].to_i <= AdminUser.roles[current_admin_user.role]
      user.role = requested
    else
      user.errors.add(:role, "cannot be higher than your own role")
      return false
    end
    true
  end

  def user_params
    params.require(:admin_user).permit(:name, :email, :password, :role)
  end

  def assignable_roles
    max_level = AdminUser.roles[current_admin_user.role]
    AdminUser.roles.select { |_, v| v <= max_level }.keys
  end
  helper_method :assignable_roles
end
