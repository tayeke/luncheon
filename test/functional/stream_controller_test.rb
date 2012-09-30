require 'test_helper'

class StreamControllerTest < ActionController::TestCase
  test "should get connect" do
    get :connect
    assert_response :success
  end

end
