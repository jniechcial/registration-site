class RobotsController < ApplicationController
	before_filter :signed_in_user, only: [:new]
	before_filter :correct_user_for_edit_and_show, only: [:show, :edit]
	before_filter :correct_user_for_update_and_create, only: [:udate, :create]
	before_action :admin_user, only: [:destroy]

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

	def edit 
		@robot = Robot.find params[:id]
	end

	def update
		@robot = Robot.find(params[:id])
    if @robot.update_attributes(robot_params)
      flash[:success] = "Robot updated"
      redirect_to @robot
    else
      render 'edit'
    end
	end

	def destroy
		@robot = Robot.find(params[:id]).destroy
		flash[:success] = "Robot destroyed"
      redirect_to admins_robots_path
	end

	private

		def robot_params
			params.require(:robot).permit(:name, :team_id, :competition_id)
		end

		def correct_user_for_edit_and_show
			if signed_in?
				@team = Robot.find_by_id(params[:id]).team
				redirect_to root_path unless @team.users.include?(current_user)
			else
				redirect_to signin_path
			end
		end

		def correct_user_for_update_and_create
			if signed_in?
				@team = Team.find_by_id(params[:robot][:team_id])
				if @team
					redirect_to root_path unless @team.users.include?(current_user)
				end
			else
				redirect_to root_path
			end
		end
end
