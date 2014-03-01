require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe Team do
	before do
		DatabaseCleaner.clean
	end

	let(:team) { FactoryGirl.create(:team) }

	subject { team }
  
  it { should be_valid }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:users) }

  describe "when name is not present" do
  	before { team.name = "" }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { team.name = "a"*51 }
  	it { should_not be_valid }
  end

  describe "with a user" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
  		team.save
  		team.add_user(user)
  	end

  	it { should be_includes_user(user) }
  	its(:users) { should include(user) }

  	describe "after removing user" do
  		before { team.remove_user(user) }

  		it { should_not be_includes_user(user) }
  		its(:users) { should_not include(user) }
  	end
  end
end
