class Admin::MembersController < Admin::BaseController
  before_action -> { require_permission(:manage_users) }
  before_action :set_member, only: [:destroy]

  def index
    @members = User.order(:name)
  end

  def destroy
    @member.destroy!
    redirect_to admin_members_path, status: :see_other, notice: "Member deleted."
  end

  private

  def set_member
    @member = User.find(params[:id])
  end
end
