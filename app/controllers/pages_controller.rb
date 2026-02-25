class PagesController < ApplicationController
  def about
    @team_members = TeamMember.order(:name)
  end

  def contact
  end

  def portfolio
  end
end
