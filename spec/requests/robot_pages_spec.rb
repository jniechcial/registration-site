require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe "Robot pages" do
	before do
		DatabaseCleaner.clean
	end

	subject { page } 

	describe "new page" do
		describe "for non-signed-in users" do
			before { get new_robot_path }

			specify { expect(response).to redirect_to(signin_path) }
		end

		describe "for signed-in users" do
			let(:submit) { "Create robot" }
			let(:user) { FactoryGirl.create(:user) }

			before do
				sign_in user
				visit new_robot_path
			end

			it { should have_selector("title", text: full_title('New robot')) }
			it { should have_xpath("//input[@value='Create robot']") }

			describe "with in-valid informations" do
				it "should not create a user" do
	        expect { click_button submit }.not_to change(Robot, :count)
	      end

	      describe "after submision" do
					before { click_button submit }

					it { should have_selector("title", text: full_title("New robot")) }
					it { should have_content('error') }
				end
			end

			describe "with forgery informations" do
				let!(:competition) { FactoryGirl.create(:competition) }
				let!(:other_team) { FactoryGirl.create(:team) }

				it "should redirect to root_url" do
					params = {}
					params_robot = {}
					params_robot['name'] = 'Example robot'
					params_robot['team_id'] = other_team.id
					params_robot['competition_id'] = competition.id
					params['robot'] = params_robot

					post robots_path, params

					expect(response).to redirect_to(signin_path)
				end
			end

			describe "with valid informations" do
				let!(:team) { FactoryGirl.create(:team) }
				let!(:competition) { FactoryGirl.create(:competition) }
				before do
					user.add_to_team(team)
					visit new_robot_path

	        fill_in "Name",         with: "Example robot"
	        select(team.name, from: 'robot_team_id')
	        select(competition.name, from: 'robot_competition_id')
	      end

	      describe "after submision" do
					before { click_button submit }
	        let(:robot) { Robot.find_by(name: 'Example robot') }

	        it { should have_selector("title", text: robot.name) }
	        it { should have_selector('div.alert.alert-success', text: 'You created new robot') }
				end
			end
		end
	end
end
