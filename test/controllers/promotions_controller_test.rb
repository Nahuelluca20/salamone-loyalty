require "test_helper"

class PromotionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer  = users(:customer)
    @admin     = users(:admin)
    @promotion = promotions(:bienvenida)
  end

  test "index requires authentication" do
    get promotions_path

    assert_redirected_to new_session_path
  end

  test "index renders for customer and lists active promotions" do
    sign_in_as(@customer)

    get promotions_path

    assert_response :success
    assert_match @promotion.name, @response.body
  end

  test "index redirects admin away" do
    sign_in_as(@admin)

    get promotions_path

    assert_redirected_to root_path
    assert_equal "Not authorized.", flash[:alert]
  end

  test "show renders with related active products" do
    sign_in_as(@customer)

    get promotion_path(@promotion)

    assert_response :success
    assert_match @promotion.name, @response.body
    assert_match products(:mate).name, @response.body
    assert_no_match products(:termo_inactivo).name, @response.body
  end
end
