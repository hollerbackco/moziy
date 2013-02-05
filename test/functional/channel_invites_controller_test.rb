require 'test_helper'

class ChannelInvitesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get accept" do
    get :accept
    assert_response :success
  end

end
