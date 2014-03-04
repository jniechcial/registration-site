require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :deletion

describe Competition do
	before do
		DatabaseCleaner.clean
	end

	let(:competition) { FactoryGirl.create(:competition) }

	subject { competition }

	it { should be_valid }
	it { should respond_to(:name) }
	it { should respond_to(:robots) }

	describe "when name is not present" do
		before { competition.name = "" }

		it { should_not be_valid }
	end
end
