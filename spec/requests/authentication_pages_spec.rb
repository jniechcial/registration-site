require 'spec_helper'

DatabaseCleaner.strategy = :deletion

describe "Authentication" do

	before do
		DatabaseCleaner.clean
	end

	subject { page }

  describe "signin page" do
  	before { visit new_user_session_path }
    it { should have_selector("title", text: "Sign in") }
    it { should have_content("Sign in") }
  end

  describe "signin" do
  	before { visit new_user_session_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector("title", text: 'Sign in') }
      it { should have_selector('div.alert.alert-alert') }
      it { should_not have_link('Settings') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-alert') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_link('Settings',    href: edit_user_registration_path(user)) }
      it { should have_link('Sign out',    href: destroy_user_session_path) }
      it { should_not have_link('Sign in', href: new_user_session_path) }
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          pending
          visit edit_user_registration_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            pending
            expect(page.source).to have_selector("title", text: 'Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          pending
          #before { visit edit_user_registration_path(user) }
          #it { should have_selector("title", text: 'Sign in') }
        end

        describe "submitting to the update action" do
          pending
          #before { patch edit_user_registration_path(user) }
          #specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      #before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        pending
        #before { get edit_user_path(wrong_user) }
        #specify { expect(response.body).not_to match(full_title('Edit user')) }
        #specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        pending
        #before { patch user_path(wrong_user) }
        #specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
