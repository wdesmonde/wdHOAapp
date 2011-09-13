require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    # what happens here is user is redirected to the signin page
    #   the test assumes that that has happened and continues from there
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
    #  we expect that this will send the user directly to their edit settings page
    #    that's assumed by the test
    response.should render_template('users/edit')
  end
end
