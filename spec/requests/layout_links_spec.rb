require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "should have a Sign Up page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "New User")
  end

  it "should have a Login page at '/login'" do
    get '/login'
    response.should have_selector('title', :content => "Login")
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Login"
    response.should have_selector('title', :content => "Login")
    click_link "New User"
    response.should have_selector('title', :content => "New User")
    
    #link to external site.  Test fails.  
    # click_link "Stowe Design"
    #response.should have_selector('title', 
    #  :content => "Stowe Design")
      #:content => "Stowe Design - News - Articles")
  end
end
