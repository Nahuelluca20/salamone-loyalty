require "test_helper"

class PromotionProductTest < ActiveSupport::TestCase
  test "cannot link the same product twice to a promotion" do
    duplicate = PromotionProduct.new(
      promotion: promotions(:bienvenida),
      product: products(:mate)
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:product_id], "has already been taken"
  end
end
