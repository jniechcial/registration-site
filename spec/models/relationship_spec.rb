require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe Relationship do
	before do
		DatabaseCleaner.clean
	end

  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }
  let(:relationship) { user.relationships.build(team_id: team.id) }

  subject { relationship }

  it { should be_valid }
  it { should respond_to(:user) }
  it { should respond_to(:team) }

  describe "when user id is not present" do
  	before { relationship.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when team id is not present" do
  	before { relationship.team_id = nil }
  	it { should_not be_valid }
  end
end
