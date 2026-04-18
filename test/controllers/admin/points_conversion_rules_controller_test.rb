require "test_helper"

class Admin::PointsConversionRulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
    @rule = points_conversion_rules(:base)
  end

  test "customer cannot access index" do
    sign_in_as(@customer)
    get admin_points_conversion_rules_path
    assert_redirected_to root_path
  end

  test "admin can view index" do
    sign_in_as(@admin)
    get admin_points_conversion_rules_path
    assert_response :success
  end

  test "admin creates inactive rule" do
    sign_in_as(@admin)
    assert_difference "PointsConversionRule.count" do
      post admin_points_conversion_rules_path, params: {
        points_conversion_rule: { pesos_per_point: 500, active: false }
      }
    end
    assert_redirected_to admin_points_conversion_rules_path
  end

  test "activating a new rule deactivates the previous active one" do
    sign_in_as(@admin)
    post admin_points_conversion_rules_path, params: {
      points_conversion_rule: { pesos_per_point: 250, active: true }
    }
    assert_redirected_to admin_points_conversion_rules_path
    assert_not @rule.reload.active?
    assert PointsConversionRule.last.active?
  end

  test "create with invalid pesos_per_point re-renders" do
    sign_in_as(@admin)
    post admin_points_conversion_rules_path, params: {
      points_conversion_rule: { pesos_per_point: 0, active: false }
    }
    assert_response :unprocessable_entity
  end

  test "admin destroys rule" do
    sign_in_as(@admin)
    assert_difference "PointsConversionRule.count", -1 do
      delete admin_points_conversion_rule_path(@rule)
    end
  end
end
