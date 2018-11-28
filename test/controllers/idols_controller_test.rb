require 'test_helper'

class IdolsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get idols_show_url
    assert_response :success
  end

  test "should get new" do
    get idols_new_url
    assert_response :success
  end

  test "should get edit" do
    get idols_edit_url
    assert_response :success
  end

end
