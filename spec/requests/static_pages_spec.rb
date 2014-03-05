require 'spec_helper'

describe "Static pages" do

	subject { page } 

	shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector("title", text: full_title(page_title)) }
  end

  describe "Home page" do
  	before do
      5.times { FactoryGirl.create(:team) }
      5.times { FactoryGirl.create(:user) }
      5.times { FactoryGirl.create(:competition) }
      5.times { FactoryGirl.create(:robot, team: Team.first, competition: Competition.first) }
      visit root_path
    end
  	let(:heading)    { 'Registration for Cyberbot Robotics Festival' }
    let(:page_title) { '' }
    let(:teams_count) { Team.all.count }
    let(:users_count) { User.all.count }
    let(:robots_count) { Robot.all.count }

    it { should have_content("Registered") }

    it {should have_selector("h4.users-number", text: "#{users_count}") }
    it {should have_selector("h4.teams-number", text: "#{teams_count}") }
    it {should have_selector("h4.robots-number", text: "#{robots_count}") }

    describe "for signed-in user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:team) { FactoryGirl.create(:team) }

      describe "in a team" do
        before do
          sign_in user
          user.add_to_team(team)
          visit root_path
        end

        it { should have_content("Your robots:") }
        it { should have_content("Your teams:") }
        it { should have_link(team.name) }
        it { should have_link("Create team") }
      end

      describe "not in a team" do
        before do
          sign_in user
          user.request_to_team(team)
          visit root_path
        end

        it { should have_content("Your robots:") }
        it { should have_content("Your teams:") }
        it { should have_content("None - 1 requests") }
        it { should have_link("Create team") }
      end
    end

    describe "for non-signed-in user" do
      it_should_behave_like "all static pages"
      it { should_not have_selector("title", text: full_title("Home") )}
    end
  end

  describe "Contact page" do
  	before { visit contact_path }
  	let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

  	it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Contact"
    expect(page).to have_selector("title", text: full_title('Contact'))
    click_link "Home"
    expect(page).to have_selector("title", text: full_title(''))
    click_link "Sign up"
    expect(page).to have_selector("title", text: full_title('Sign up'))
  end
end
