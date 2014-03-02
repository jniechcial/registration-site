class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @team = Team.find(params[:relationship][:team_id])
    current_user.request_to_team(@team)
    redirect_to teams_path
  end
end
