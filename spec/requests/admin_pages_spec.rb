require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe "Admin pages" do
	before do
		DatabaseCleaner.clean
	end

	subject { page }

	let!(:user) { FactoryGirl.create(:user) }
	let!(:admin) { FactoryGirl.create(:admin) }

  describe "for non-signed-in user" do
    before { get admins_path }

    specify { expect(response).to redirect_to(new_user_session_path) }
  end

  describe "for signed-in non-admin users" do
  	before do
  		sign_in user
			get admins_path
  	end

  	specify { expect(response).to redirect_to(root_path) }
  end

  describe "for signed-in admin users" do
  	before do
  		sign_in admin
  	end

  	describe "home page" do
  		before { visit admins_path }

  		it { should have_link("All users", href: admins_users_path) }
  		it { should have_link("All robots", href: admins_robots_path) }
  		it { should have_link("All teams", href: admins_teams_path) }
  	end

  	describe "users page" do
  		before { visit admins_users_path }

  		it { should have_content("All users") }
  		it { should have_selector("title", text: full_title("All users")) }
  		it { should have_content(user.name) }
  		it { should have_content(admin.name) }
  		it { should have_link("X", href: user_path(user)) }
  		it { should_not have_link("X", href: user_path(admin)) }
  		it "should be able to delete another user" do
          expect do
            click_link('X')
          end.to change(User, :count).by(-1)
        end
  	end

    describe "teams page" do
      let!(:team) { FactoryGirl.create(:team) }
      let!(:other_team) { FactoryGirl.create(:team) }
      before do
        team.add_user(user)
        other_team.add_user(admin)
        visit admins_teams_path
      end

      it { should have_content("All teams") }
      it { should have_selector("title", text: full_title("All teams")) }
      it { should have_content(user.name) }
      it { should have_content(admin.name) }
      it { should have_content(team.name) }
      it { should have_content(other_team.name) }
      it { should have_link("X", href: team_path(team)) }
      it "should be able to delete another team" do
          expect do
            click_link('X')
          end.to change(Team, :count).by(-1)
        end
    end

    describe "robots page" do
      let!(:team) { FactoryGirl.create(:team) }
      let!(:competition) { FactoryGirl.create(:competition) }
      let!(:robot) { FactoryGirl.create(:robot, team: team, competition: competition) }
      let!(:other_robot) { FactoryGirl.create(:robot, team: team, competition: competition) }
      before do
        visit admins_robots_path
      end

      it { should have_content("All robots") }
      it { should have_selector("title", text: full_title("All robots")) }
      it { should have_content(robot.name) }
      it { should have_content(team.name) }
      it { should have_content(competition.name) }
      it { should have_link("X", href: robot_path(robot)) }
      it "should be able to delete another robot" do
          expect do
            click_link('X')
          end.to change(Robot, :count).by(-1)
        end
    end
  end
end
