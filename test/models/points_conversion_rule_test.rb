require "test_helper"

class PointsConversionRuleTest < ActiveSupport::TestCase
  test "pesos_per_point must be positive integer" do
    rule = PointsConversionRule.new(pesos_per_point: 0)
    assert_not rule.valid?
    assert_includes rule.errors[:pesos_per_point], "must be greater than 0"
  end

  test "active_rule returns the currently active rule" do
    assert_equal points_conversion_rules(:base), PointsConversionRule.active_rule
  end

  test "saving a new active rule deactivates the previous active one" do
    new_rule = PointsConversionRule.create!(pesos_per_point: 150, active: true)

    assert new_rule.active?
    assert_not points_conversion_rules(:base).reload.active?
  end

  test "updating a rule to active deactivates the previous active one" do
    legacy = points_conversion_rules(:legacy)
    legacy.update!(active: true)

    assert legacy.reload.active?
    assert_not points_conversion_rules(:base).reload.active?
  end

  test "partial unique index rejects two active rules when callbacks are bypassed" do
    second = PointsConversionRule.create!(pesos_per_point: 300, active: false)

    assert_raises(ActiveRecord::RecordNotUnique) do
      second.update_columns(active: true)
    end
  end
end
