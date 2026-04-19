require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:customer) }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "create with customer credentials redirects to products" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to products_path
    assert cookies[:session_id]
  end

  test "create with admin credentials redirects to admin products" do
    post session_path, params: { email_address: users(:admin).email_address, password: "password" }

    assert_redirected_to admin_products_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(User.take)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end
end
