require "test_helper"

class Admin::IssuesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_issues_index_url
    assert_response :success
  end
end
