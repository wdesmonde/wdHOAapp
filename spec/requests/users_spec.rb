require 'spec_helper'

describe "Users" do
  describe "signup" do

    describe "failure" do
      it "should not make a new user if all fields blank" do
        lambda do
          visit signup_path
          fill_in "Name",  :with => ""
          fill_in "Email",  :with => ""
          fill_in "Password",  :with => ""
          fill_in "Confirm Your Password",  :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end

      it "should not make a new user if name blank others valid" do
        lambda do
          visit signup_path
          fill_in "Name",  :with => ""
          fill_in "Email",  :with => "someone@won.com"
          fill_in "Password",  :with => "foolishbar"
          fill_in "Confirm Your Password",  :with => "foolishbar"
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
          response.should have_selector(
            "input#user_password" , :content => "") 
          response.should have_selector(
            "input#user_password_confirmation" , :content => "") 
        end.should_not change(User, :count)
      end


      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",  :with => "Doogma Mistatef"
          fill_in "Email",  :with => "doogma@mistatef.net"
          fill_in "Password",  :with => "foolishbar"
          fill_in "Confirm Your Password",  :with => "foolishbar"
          click_button
          response.should have_selector("div.flash.success",
             :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end


    end

  end

=begin
This doesn't work yet because users_index_path doesn't work.
Commenting this out for now.
  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_index_path
      response.status.should be(200)
    end
  end
=end
end
