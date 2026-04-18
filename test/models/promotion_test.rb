require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test "requires name" do
    promo = Promotion.new(points_for_redemption: 100)
    assert_not promo.valid?
    assert_includes promo.errors[:name], "can't be blank"
  end

  test "points_for_redemption must be positive integer" do
    promo = Promotion.new(name: "x", points_for_redemption: 0)
    assert_not promo.valid?
    assert_includes promo.errors[:points_for_redemption], "must be greater than 0"
  end

  test "has many products through promotion_products" do
    assert_includes promotions(:bienvenida).products, products(:mate)
  end

  test "active scope returns only active promotions" do
    assert_includes Promotion.active, promotions(:bienvenida)
  end
end
