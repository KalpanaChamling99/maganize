class Admin::RolesController < Admin::BaseController
  before_action -> { require_permission(:manage_roles) }
  before_action :set_role, only: [:edit, :update]

  def index
    @roles = Role.includes(:admin_users).order(:name)
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to admin_roles_path, notice: "Role \"#{@role.name}\" was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @role.update(role_params)
      redirect_to admin_roles_path, notice: "Role \"#{@role.name}\" was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    permitted = params.require(:role).permit(:name, permissions: [])
    # The permissions checkboxes submit an array; filter out blanks
    permitted[:permissions] = Array(permitted[:permissions]).reject(&:blank?)
    permitted
  end
end
