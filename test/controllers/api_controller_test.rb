require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get api_search_url
    assert_response :success
  end

end
