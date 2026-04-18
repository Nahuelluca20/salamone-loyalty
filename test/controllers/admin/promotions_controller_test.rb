require "test_helper"

class Admin::PromotionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
    @promotion = promotions(:bienvenida)
    @product = products(:mate)
  end

  test "customer cannot access index" do
    sign_in_as(@customer)
    get admin_promotions_path
    assert_redirected_to root_path
  end

  test "admin can view index" do
    sign_in_as(@admin)
    get admin_promotions_path
    assert_response :success
  end

  test "admin creates promotion with products" do
    sign_in_as(@admin)
    assert_difference "Promotion.count" do
      post admin_promotions_path, params: {
        promotion: {
          name: "Nueva promo",
          points_for_redemption: 300,
          active: true,
          product_ids: [ @product.id ]
        }
      }
    end
    promo = Promotion.last
    assert_redirected_to admin_promotion_path(promo)
    assert_includes promo.products, @product
    assert_equal @admin, promo.created_by
  end

  test "admin updates promotion product_ids" do
    sign_in_as(@admin)
    other = Product.create!(name: "Otro", price: 500)
    patch admin_promotion_path(@promotion), params: {
      promotion: { product_ids: [ other.id ] }
    }
    assert_redirected_to admin_promotion_path(@promotion)
    assert_equal [ other ], @promotion.reload.products
  end

  test "create with invalid params re-renders" do
    sign_in_as(@admin)
    post admin_promotions_path, params: { promotion: { name: "", points_for_redemption: 0 } }
    assert_response :unprocessable_entity
  end

  test "admin destroys promotion" do
    sign_in_as(@admin)
    assert_difference "Promotion.count", -1 do
      delete admin_promotion_path(@promotion)
    end
  end
end
