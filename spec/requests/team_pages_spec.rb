require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe "Team pages" do

	before do
		DatabaseCleaner.clean
	end

	subject { page }

	describe "edit page" do
		let(:team) { FactoryGirl.create(:team) }
		let (:user) { FactoryGirl.create(:user) }

		describe "for non-signed-in users" do
			before { get edit_team_path(team) }
			specify { expect(response).to redirect_to(signin_path) }
		end

		describe "for signed in users not from a team" do
			before do
				sign_in user
				get edit_team_path(team)
			end

			specify { expect(response).to redirect_to(signin_path) }
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
			specify { expect(response).to redirect_to(signin_path) }
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

  describe "team page" do
  	let(:team) { FactoryGirl.create(:team) }
    before { visit team_path(team) }
    it { should have_selector("title", text: team.name) }
    it { should have_selector("h1", text: team.name) }

    describe "for non enrolled users" do
    	let(:user) { FactoryGirl.create(:user) }
    	before { sign_in user }

    	it { should_not have_content("Create robot") }
    	it { should_not have_link("Edit", href: edit_team_path(team)) }
    end

    describe "for enrolled users" do
    	let(:user) { FactoryGirl.create(:user) }
    	before do
    		sign_in user
    		team.add_user(user)
    		visit team_path(team)
    	end

    	it { should have_link("Edit", href: edit_team_path(team)) }
    end

    describe "should include all team users" do
    	let(:user) { FactoryGirl.create(:user) }
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
end
