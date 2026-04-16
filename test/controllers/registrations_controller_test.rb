require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
  end

  test "create with valid params creates customer and signs in" do
    assert_difference "User.count" do
      post registration_path, params: { user: { email_address: "new@example.com", password: "secret123", password_confirmation: "secret123" } }
    end

    user = User.find_by(email_address: "new@example.com")
    assert user.customer?
    assert_not_nil user.loyalty_account
    assert cookies[:session_id]
  end

  test "create with invalid params renders form" do
    assert_no_difference "User.count" do
      post registration_path, params: { user: { email_address: "", password: "short", password_confirmation: "nope" } }
    end

    assert_response :unprocessable_entity
  end

  test "cannot set admin role via params" do
    post registration_path, params: { user: { email_address: "sneaky@example.com", password: "secret123", password_confirmation: "secret123", role: :admin } }

    user = User.find_by(email_address: "sneaky@example.com")
    assert user.customer?
  end
end
