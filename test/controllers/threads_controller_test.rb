require 'test_helper'

class ThreadsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get threads_show_url
    assert_response :success
  end

end
