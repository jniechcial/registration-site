require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe User do

	before do
		DatabaseCleaner.clean
	end

	before { @user = User.new(name: "Example", email: "user@example.com", password: "foobar", terms: true, agreement: true, password_confirmation: "foobar", city: "Example City", tshirt: "XL") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:tshirt) }
  it { should respond_to(:city) }
  it { should respond_to(:terms) }
  it { should respond_to(:agreement) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:accepted_relationships) }
  it { should respond_to(:pending_relationships) }
  it { should respond_to(:teams) }
  it { should respond_to(:requested_teams) }
  it { should respond_to(:robots) }

	it { should be_valid }
  it { should_not be_admin }

  describe "when admin attribute is set to true" do
    before do
      @user.save
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when terms are not accepted" do
    before { @user.terms = false }

    it { should_not be_valid }
  end

  describe "when agreement is not accepted" do
    before { @user.agreement = false }

    it { should_not be_valid }
  end

  describe "when city is not present" do
    before { @user.city = " " }

    it { should_not be_valid }
  end

  describe "when tshirt is not present" do
    before { @user.tshirt = " " }

    it { should_not be_valid }
  end

	describe "when name is not present" do
		before { @user.name = " " }

		it { should_not be_valid }
	end

	describe "when email is not present" do
    before { @user.email = " " }

    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }

    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
	  before do
	    @user = User.new(name: "Example User", email: "user@example.com", password: " ", password_confirmation: " ")
	  end

	  it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
	  before { @user.password_confirmation = "mismatch" }

	  it { should_not be_valid }
	end

	describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

	describe "return value of authenticate method" do
	  before { @user.save }
	  let(:found_user) { User.find_by(email: @user.email) }

	  describe "with valid password" do
	    it { should eq found_user.authenticate(@user.password) }
	  end

	  describe "with invalid password" do
	    let(:user_for_invalid_password) { found_user.authenticate("invalid") }

	    it { should_not eq user_for_invalid_password }
	    specify { expect(user_for_invalid_password).to be_false }
	  end
	end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "in a team" do
    let(:team) { FactoryGirl.create(:team) }
    before do
      @user.save
      @user.add_to_team(team)
    end

    it { should be_in_team(team) }
    its(:teams)  { should include(team) }

    describe "after unroll from a team" do
      before { @user.remove_from_team(team) }

      it { should_not be_in_team(team) }
      its(:teams) { should_not include(team) }
    end
  end

  describe "requested to a team" do
    let(:team) { FactoryGirl.create(:team) }
    before do
      @user.save
      @user.request_to_team(team)
    end

    it { should be_requested_to_team(team) }
    it { should_not be_in_team(team) }
    its(:requested_teams) { should include(team) }
    its(:teams) { should_not include(team) }

    describe "and enrolled" do
      before do
        team.accept_requested_user(@user)
      end

      it { should_not be_requested_to_team(team) }
      it { should be_in_team(team) }
      its(:requested_teams) { should_not include(team) }
      its(:teams) { should include(team) }

      describe "and then destroyed" do
        before do
          team.remove_user(@user)
        end

        it { should_not be_requested_to_team(team) }
        it { should_not be_in_team(team) }
        its(:requested_teams) { should_not include(team) }
        its(:teams) { should_not include(team) }
      end
    end

    describe "and rejected" do
      before do
        team.remove_user(@user)
      end

      it { should_not be_requested_to_team(team) }
      it { should_not be_in_team(team) }
      its(:requested_teams) { should_not include(team) }
      its(:teams) { should_not include(team) }
    end
  end

  describe "in a team with a robot" do
    before do
      @user.save
      @team = FactoryGirl.create(:team)
      @other_team = FactoryGirl.create(:team)
      @competition = FactoryGirl.create(:competition)
      @robot =  FactoryGirl.create(:robot, team: @team, competition: @competition)
      @other_robot = FactoryGirl.create(:robot, team: @other_team, competition: @competition)

      @user.add_to_team(@team)
    end

    its(:robots) { should include(@robot) }
    its(:robots) { should_not include(@other_robot) }
  end
end
