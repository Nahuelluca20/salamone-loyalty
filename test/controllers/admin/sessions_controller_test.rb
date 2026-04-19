require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_admin_session_path
    assert_response :success
  end

  test "create with admin credentials redirects to admin products" do
    post admin_session_path, params: { email_address: "admin@example.com", password: "password" }

    assert_redirected_to admin_products_path
    assert cookies[:session_id]
  end

  test "create with customer credentials is rejected" do
    post admin_session_path, params: { email_address: "customer@example.com", password: "password" }

    assert_redirected_to new_admin_session_path
    assert_nil cookies[:session_id]
  end

  test "create with invalid credentials" do
    post admin_session_path, params: { email_address: "admin@example.com", password: "wrong" }

    assert_redirected_to new_admin_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    admin = users(:admin)
    sign_in_as(admin)

    delete admin_session_path

    assert_redirected_to new_admin_session_path
    assert_empty cookies[:session_id]
  end
end
