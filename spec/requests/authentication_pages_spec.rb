require 'spec_helper'

DatabaseCleaner.strategy = :deletion

describe "Authentication" do

	before do
		DatabaseCleaner.clean
	end

	subject { page }

  describe "signin page" do
  	before { visit signin_path }
    it { should have_selector("title", text: "Sign in") }
    it { should have_content("Sign in") }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector("title", text: 'Sign in') }
      it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector("title", text: user.name) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }


      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_selector("title", text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
end
