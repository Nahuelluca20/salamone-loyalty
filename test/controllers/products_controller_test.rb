require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer = users(:customer)
    @admin    = users(:admin)
    @product  = products(:mate)
    @inactive = products(:termo_inactivo)
  end

  test "index requires authentication" do
    get products_path

    assert_redirected_to new_session_path
  end

  test "index renders for customer and lists only active products" do
    sign_in_as(@customer)

    get products_path

    assert_response :success
    assert_match @product.name, @response.body
    assert_no_match @inactive.name, @response.body
  end

  test "index redirects admin away" do
    sign_in_as(@admin)

    get products_path

    assert_redirected_to root_path
    assert_equal "Not authorized.", flash[:alert]
  end

  test "show renders for customer and links related active promotions" do
    sign_in_as(@customer)

    get product_path(@product)

    assert_response :success
    assert_match @product.name, @response.body
    assert_match promotions(:bienvenida).name, @response.body
  end

  test "show 404s on inactive product" do
    sign_in_as(@customer)

    get product_path(@inactive)

    assert_response :not_found
  end
end
