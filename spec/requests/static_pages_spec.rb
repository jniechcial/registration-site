require 'spec_helper'

describe "Static pages" do

	subject { page } 

	let(:base_title) { "Cyberbot Robotics Festival 2014" }

  describe "Home page" do
  	before { visit '/static_pages/home' }

    it { should have_content("Registration for Cyberbot Robotics Festival") }
    it { should have_selector("title", text: "#{base_title} | Home" )}
  end

  describe "Contact page" do
  	before { visit '/static_pages/contact' }

  	it { should have_content("Contact") }
  	it { should have_selector("title", text: "#{base_title} | Contact" )}
  end
end
