require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe Robot do
	before do
		DatabaseCleaner.clean
	end

	let(:team) { FactoryGirl.create(:team) }
	let(:competition) { FactoryGirl.create(:competition) }
  let(:robot) { FactoryGirl.create(:robot, team: team, competition: competition) }

  subject { robot }

  it { should be_valid }
  it { should respond_to(:name) }
  it { should respond_to(:competition) }
  it { should respond_to(:team) }

  describe "when no name" do
  	before { robot.name = "" }
  	it { should_not be_valid }
  end

  describe "when no competition" do
  	before { robot.competition = nil }
  	it { should_not be_valid }
  end

  describe "when no team" do
  	before { robot.team = nil }
  	it { should_not be_valid }
  end
end
