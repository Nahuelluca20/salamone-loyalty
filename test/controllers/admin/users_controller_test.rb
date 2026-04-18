require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
  end

  test "customer cannot access search" do
    sign_in_as(@customer)
    get admin_users_search_path, params: { q: "cu" }
    assert_redirected_to root_path
  end

  test "search with short query returns empty" do
    sign_in_as(@admin)
    get admin_users_search_path, params: { q: "c" }
    assert_response :success
    assert_no_match @customer.email_address, response.body
  end

  test "search matches customer email prefix" do
    sign_in_as(@admin)
    get admin_users_search_path, params: { q: "cust" }
    assert_response :success
    assert_match @customer.email_address, response.body
  end

  test "search excludes admin users" do
    sign_in_as(@admin)
    get admin_users_search_path, params: { q: "admin" }
    assert_response :success
    assert_no_match @admin.email_address, response.body
  end
end
