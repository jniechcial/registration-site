class RobotsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user, only: [:create]
	def new
		@robot = Robot.new
	end

	def show
		@robot = Robot.find params[:id]
	end

	def create
		@robot = Robot.new(robot_params)
		if @robot.save
			flash[:success] = "You created new robot"
      redirect_to @robot
		else
			render 'new'
		end
	end

	private

		def robot_params
			params.require(:robot).permit(:name, :team_id, :competition_id)
		end

		def correct_user
			@team = Team.find_by_id params[:robot][:team_id]
			if @team
				redirect_to root_path unless @team.users.include?(current_user)
			end
		end
end
