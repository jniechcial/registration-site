class AdminsController < ApplicationController
	before_action :signed_in_user
	before_action :admin_user

	def home
	end

	def users
		@users = User.all
	end

	def teams
		@teams = Teams.all
	end

	def robots
		@robots = Robots.all
	end
end
