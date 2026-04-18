require "test_helper"

class Admin::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
    @product = products(:mate)
  end

  test "unauthenticated cannot access index" do
    get admin_products_path
    assert_redirected_to new_session_path
  end

  test "customer cannot access index" do
    sign_in_as(@customer)
    get admin_products_path
    assert_redirected_to root_path
    assert_equal "Not authorized.", flash[:alert]
  end

  test "admin can view index" do
    sign_in_as(@admin)
    get admin_products_path
    assert_response :success
  end

  test "index filters by status" do
    sign_in_as(@admin)
    get admin_products_path(status: "inactive")
    assert_response :success
  end

  test "admin can view show" do
    sign_in_as(@admin)
    get admin_product_path(@product)
    assert_response :success
  end

  test "admin can view new" do
    sign_in_as(@admin)
    get new_admin_product_path
    assert_response :success
  end

  test "admin creates product" do
    sign_in_as(@admin)
    assert_difference "Product.count" do
      post admin_products_path, params: { product: { name: "Nuevo", price: 1000, active: true } }
    end
    assert_redirected_to admin_product_path(Product.last)
    assert_equal @admin, Product.last.created_by
  end

  test "create with invalid params re-renders" do
    sign_in_as(@admin)
    post admin_products_path, params: { product: { name: "", price: 1 } }
    assert_response :unprocessable_entity
  end

  test "admin updates product" do
    sign_in_as(@admin)
    patch admin_product_path(@product), params: { product: { name: "Mate actualizado" } }
    assert_redirected_to admin_product_path(@product)
    assert_equal "Mate actualizado", @product.reload.name
  end

  test "admin can soft-delete via active flag" do
    sign_in_as(@admin)
    patch admin_product_path(@product), params: { product: { active: false } }
    assert_not @product.reload.active?
  end

  test "admin destroys product" do
    sign_in_as(@admin)
    assert_difference "Product.count", -1 do
      delete admin_product_path(@product)
    end
    assert_redirected_to admin_products_path
  end
end
