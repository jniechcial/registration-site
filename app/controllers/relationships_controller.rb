class RelationshipsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_team_member, only: [:destroy, :update]

  def create
    @team = Team.find(params[:relationship][:team_id])
    current_user.request_to_team(@team)
    redirect_to teams_path
  end

  def destroy
  	@user = @relationship.user
  	@team.remove_user(@user)
  	redirect_to @team
  end

  def update
  	@user = @relationship.user
  	@team.add_user(@user)
  	redirect_to @team
  end

  private

  	# before filters
  	def correct_team_member
  		@relationship = Relationship.find(params[:id])
  		@team = @relationship.team
  		redirect_to root_path unless @team.includes_user?(current_user)
  	end
end
