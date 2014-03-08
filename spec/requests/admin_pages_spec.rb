require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe "Admin pages" do
	before do
		DatabaseCleaner.clean
	end

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:admin) { FactoryGirl.create(:admin) }

  describe "for non-signed-in user" do
    before { get admins_path }

    specify { expect(response).to redirect_to(signin_path) }
  end

  describe "for signed-in non-admin users" do
  	before do
  		sign_in user, no_capybara: true
			get admins_path
  	end

  	specify { expect(response).to redirect_to(root_path) }
  end

  describe "for signed-in admin users" do
  	before { sign_in admin }

  	describe "home page" do
  		before { visit admins_path }

  		it { should have_link("All users", href: admins_users_path) }
  		it { should have_link("All robots", href: admins_robots_path) }
  		it { should have_link("All teams", href: admins_teams_path) }
  	end
  end
end
