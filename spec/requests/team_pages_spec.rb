require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe "Team pages" do

	before do
		DatabaseCleaner.clean
	end

	subject { page }

	describe "index page" do
		let!(:teams) { 40.times { FactoryGirl.create(:team) } }
		before do
			visit teams_path
		end

		it { should have_selector("div.pagination") }
	end

	describe "index page for signed-in user" do
		let(:user) { FactoryGirl.create(:user) }
		let!(:team) { FactoryGirl.create(:team) }

		before do
			sign_in user
			visit teams_path
		end

		it { should have_content(team.name) }
		it { should have_button("Join") }

		describe "after requesting to join" do
			it "should increment its requests by one" do
				expect do
          click_button 'Join'
        end.to change(user.requested_teams, :count).by(1)
			end

			it "should increment team requests by one" do
				expect do
					click_button 'Join'
				end.to change(team.requested_users, :count).by(1)
			end

			describe "should not show join anymore" do
				before do
					click_button 'Join'
				end

				it { should_not have_link('Join') }
			end
		end

		describe "after joining the team" do
			before do
				team.add_user(user)
				visit teams_path
			end

			it { should_not have_link('Join') }
		end
	end

	describe "index page for non-signed-in user" do
		before do
			visit teams_path
		end

		it { should_not have_content("Create team")}
	end

	describe "edit page" do
		let(:team) { FactoryGirl.create(:team) }
		let(:user) { FactoryGirl.create(:user) }

		describe "for non-signed-in users" do
			before { get edit_team_path(team) }
			specify { expect(response).to redirect_to(new_user_session_path) }
		end

		describe "for signed in users not from a team" do
			before do
				sign_in user
				get edit_team_path(team)
			end

			specify { expect(response).to redirect_to(new_user_session_path) }
		end

		describe "for signed in users from a team" do
			before do
				team.add_user(user)
				sign_in user
				visit edit_team_path(team)
			end

			it { should have_selector("title", text: full_title("Edit team #{team.name}"))}
			it { should have_xpath("//input[@value='Update team']") }

			describe "with invalid data" do
				before do
					fill_in "Name",             with: ""
	        fill_in "Description",      with: ""
					click_button "Update team"
				end

				it { should have_content('error') }
			end

			describe "with valid data" do
				let(:new_name)  { "New Name" }
	      let(:new_description) { "Some other desc." }
	      before do
	        fill_in "Name",             with: new_name
	        fill_in "Description",      with: new_description
	        click_button "Update team"
	      end

	      it { should have_selector("title", text: new_name) }
	      it { should have_selector('div.alert.alert-success') }
	      specify { expect(team.reload.name).to  eq new_name }
	      specify { expect(team.reload.description).to eq new_description }
			end
		end
	end

	describe "new team page" do
		
		describe "for non-signed-in users" do
			before { get new_team_path }
			specify { expect(response).to redirect_to(new_user_session_path) }
		end

		describe "for signed in users" do
			let (:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				visit new_team_path
			end

			it { should have_selector("title", text: full_title("New team"))}
			it { should have_xpath("//input[@value='Create team']") }

			describe "with invalid data" do
				it "should not create a team" do
	        expect { click_button "Create team" }.not_to change(Team, :count)
	      end
				
				describe "after submision" do
					before { click_button "Create team" }

					it { should have_selector("title", text: full_title("New team")) }
					it { should have_content('error') }
				end
			end

			describe "with valid data" do
				before do
	        fill_in "Name",         with: "Example team"
	        fill_in "Description",  with: "Lorem ipsum solor dil amet."
	      end

				it "should create a team" do
					expect { click_button "Create team" }.to change(Team, :count).by(1)
				end

				describe "after submision" do
					before { click_button "Create team" }
	        let(:team) { Team.find_by(name: 'Example team') }

	        it { should have_selector("title", text: team.name) }
	        it { should have_selector('div.alert.alert-success', text: 'You created new team') }
	        it { should have_selector("li", text: user.name) }
				end
			end
		end
	end

  describe "show page" do
  	let(:team) { FactoryGirl.create(:team) }
  	let(:user) { FactoryGirl.create(:user) }

  	describe "for signed-in users" do
	    before do
	    	sign_in user
	    	visit team_path(team)
	    end

	    it { should have_selector("title", text: team.name) }
	    it { should have_selector("h1", text: team.name) }

	    describe "for non enrolled users" do

	    	it { should_not have_content("Create robot") }
	    	it { should_not have_link("Edit", href: edit_team_path(team)) }
	    	it { should_not have_selector("h4", text: "Open requests") }
	    end

	    describe "for enrolled users" do
	    	before do
	    		team.add_user(user)
	    		visit team_path(team)
	    	end

	    	it { should have_link("Edit team", href: edit_team_path(team)) }

	    	describe "should show all robots" do
	    		let(:competition) { FactoryGirl.create(:competition) }
	    		let!(:robot) { FactoryGirl.create(:robot, team: team, competition: competition) }
	    		before do
	    			visit team_path(team)
	    		end

	    		it { should have_content("Create robot") }
	    		it { should have_link(robot.name, href: robot_path(robot)) }
	    		it { should have_content("Robots") }
	    	end

	    	describe "should show all open requests" do
		    	let(:other_user) { FactoryGirl.create(:user) }
		    	before do
		    		other_user.request_to_team(team)
		    		visit team_path(team)
		    	end

		    	it { should have_selector("h4", text: "Open requests") }
		    	it { should have_selector("li", text: other_user.name) }
		    	it { should have_button("Accept") }
		    	it { should have_button("Decline") }

		    	describe "and after clicking accept request" do
		    		it "should increment its teams by one" do
							expect do
			          click_button 'Accept'
			        end.to change(other_user.teams, :count).by(1)
						end
		    	end

		    	describe "and after clicking decline request" do
		    		it "should decrement its requested teams by one" do
							expect do
			          click_button 'Decline'
			        end.to change(other_user.requested_teams, :count).by(-1)
						end
		    	end
		    end
	    end

	    describe "should include all team users" do
	    	let(:other_user) { FactoryGirl.create(:user) }
	    	before do
	    		team.add_user(user)
	    		team.add_user(other_user)
	    		visit team_path(team)
	    	end

	    	it { should have_selector("li", text: user.name) }
	    	it { should have_selector("li", text: other_user.name) }
	    end

	    
	  end

	  describe "for non-signed-in users" do
	  	before { get new_team_path }
			specify { expect(response).to redirect_to(new_user_session_path) }
	  end
  end
end
