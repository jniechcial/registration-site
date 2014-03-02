class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @team = Team.find(params[:relationship][:team_id])
    current_user.request_to_team(@team)
    redirect_to teams_path
  end

  def destroy
  	@relationship = Relationship.find(params[:id])
  	@team = @relationship.team
  	@user = @relationship.user
  	@team.remove_user(@user)
  	redirect_to @team
  end

  def update
  	@relationship = Relationship.find(params[:id])
  	@team = @relationship.team
  	@user = @relationship.user
  	@team.add_user(@user)
  	redirect_to @team
  end
end
