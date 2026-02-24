class Admin::TeamMembersController < Admin::BaseController
  before_action :set_team_member, only: [:edit, :update, :destroy]
  before_action -> { require_permission(:manage_team_members) }, only: [:new, :create, :edit, :update, :destroy]

  def index
    @team_members = TeamMember.order(:name)
  end

  def new
    @team_member = TeamMember.new
  end

  def edit
  end

  def create
    @team_member = TeamMember.new(team_member_params)
    if @team_member.save
      redirect_to admin_team_members_path, notice: "Team member \"#{@team_member.name}\" was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @team_member.update(team_member_params)
      redirect_to admin_team_members_path, notice: "Team member updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @team_member.name
    @team_member.destroy!
    redirect_to admin_team_members_path, status: :see_other, notice: "\"#{name}\" was removed."
  end

  private

  def set_team_member
    @team_member = TeamMember.find_by(slug: params[:id]) || TeamMember.find(params[:id])
  end

  def team_member_params
    params.require(:team_member).permit(:name, :role, :bio, :slug, :avatar)
  end
end
