require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "requires name" do
    product = Product.new(price: 100)
    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "price must be non-negative" do
    product = Product.new(name: "x", price: -1)
    assert_not product.valid?
    assert_includes product.errors[:price], "must be greater than or equal to 0"
  end

  test "active scope returns only active products" do
    assert_includes Product.active, products(:mate)
    assert_not_includes Product.active, products(:termo_inactivo)
  end

  test "inactive scope returns only inactive products" do
    assert_includes Product.inactive, products(:termo_inactivo)
    assert_not_includes Product.inactive, products(:mate)
  end

  test "has many promotions through promotion_products" do
    assert_includes products(:mate).promotions, promotions(:bienvenida)
  end

  test "created_by is optional" do
    product = Product.new(name: "x", price: 1, created_by: nil)
    assert product.valid?
  end
end
