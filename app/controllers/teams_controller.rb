class TeamsController < ApplicationController
	before_action :signed_in_user, only: [:new, :create, :edit, :update, :show]
	before_action :correct_user, only: [:edit, :update]

	def index
		@teams = Team.all.paginate(page: params[:page], :per_page => 10)
	end

	def show
		@team = Team.find params[:id]
	end

	def new
		@team = Team.new
	end

	def create
		#@team = current_user.teams.build(team_params) # why this is not working?
		@team = Team.new(team_params)
		if @team.save
			@team.add_user(current_user)
			flash[:success] = "You created new team"
      redirect_to @team
		else
			render 'new'
		end
	end

	def edit 
		@team = Team.find params[:id]
	end

	def update
		@team = Team.find(params[:id])
    if @team.update_attributes(team_params)
      flash[:success] = "Team updated"
      redirect_to @team
    else
      render 'edit'
    end
	end

	private

		def team_params
			params.require(:team).permit(:name, :description)
		end

		def signed_in_user
	    unless signed_in?
	      store_location
	      redirect_to signin_url, notice: "Please sign in."
	    end
	  end

	  def correct_user
	  	@users = Team.find_by_id(params[:id]).users
	  	redirect_to(root_url) unless @users.include?(current_user)
	  end
end
