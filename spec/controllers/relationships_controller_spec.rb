require 'spec_helper'

describe RelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }
  let(:other_user) { FactoryGirl.create(:user) }

  before do
    sign_in user, no_capybara: true
    other_user.request_to_team(team)
    team.add_user(user)
  end

  # could not make up how to write it right now :)
end