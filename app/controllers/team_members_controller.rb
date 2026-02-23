class TeamMembersController < ApplicationController
  def show
    @team_member = TeamMember.find_by!(slug: params[:id])
    @articles = @team_member.articles.includes(:category, :tags)
                            .merge(Article.published)
                            .order(published_at: :desc)
                            .page(params[:page]).per(10)
  end
end
