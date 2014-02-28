require 'spec_helper'

describe "Static pages" do

	subject { page } 

  describe "Home page" do
  	before { visit '/static_pages/home' }

    it { should have_content("Registration for Cyberbot Robotics Festival") }
    it { should have_selector("title", text: "Cyberbot Robotics Festival 2014 | Home" )}
  end

  describe "Contact page" do
  	before { visit '/static_pages/contact' }

  	it { should have_content("Contact") }
  	it { should have_selector("title", text: "Cyberbot Robotics Festival 2014 | Contact" )}
  end
end
