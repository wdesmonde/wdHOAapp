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

  it "should have a Signin page at '/signin'" do
    get '/signin'
    response.should have_selector('title', :content => "Sign in")
  end

  it "should have the right links on the layout when not signed in" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
=begin
# commenting out this test.  covered below, and
#   now this link only appears under certain conditions
    click_link "Sign in"
    response.should have_selector('title', :content => "Sign in")
=end
    click_link "New User"
    response.should have_selector('title', :content => "New User")
    
    #link to external site.  Test fails.  
    # click_link "Stowe Design"
    #response.should have_selector('title', 
    #  :content => "Stowe Design")
      #:content => "Stowe Design - News - Articles")
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
        :content => "Sign in")
    end
  end

  describe "when signed in" do
     before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
        :content => "Sign out")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
        :content => "Profile")
    end

    it "should not have a signin link on the home page" do
      visit root_path
      # a kluge?  I don't want to use text because that could change
      #   not sure what the right HTML tag is, so I just put in an
      #   anchor tag with an id
      response.should have_selector("a", :id => "is_signed_in")
    end
  end
end
