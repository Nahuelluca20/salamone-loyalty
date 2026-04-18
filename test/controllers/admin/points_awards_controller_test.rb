require "test_helper"

class Admin::PointsAwardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @customer = users(:customer)
    @rule = points_conversion_rules(:base) # pesos_per_point: 100, active
  end

  test "customer cannot access new" do
    sign_in_as(@customer)
    get new_admin_points_award_path
    assert_redirected_to root_path
  end

  test "new redirects when no active rule exists" do
    sign_in_as(@admin)
    @rule.update!(active: false)
    get new_admin_points_award_path
    assert_redirected_to admin_points_conversion_rules_path
    assert_equal "Configurá una regla de conversión activa primero.", flash[:alert]
  end

  test "new renders when active rule exists" do
    sign_in_as(@admin)
    get new_admin_points_award_path
    assert_response :success
  end

  test "create awards points with floor rounding" do
    sign_in_as(@admin)
    assert_difference -> { @customer.loyalty_account.reload.points_balance }, 3 do
      post admin_points_awards_path, params: {
        email_address: @customer.email_address,
        amount_ars: 350
      }
    end
    txn = @customer.loyalty_account.loyalty_transactions.last
    assert_equal 3, txn.points
    assert txn.earn?
    assert_equal 35_000, txn.amount_cents
    assert_equal @rule, txn.source
    assert_match @admin.email_address, txn.note
    assert_redirected_to new_admin_points_award_path
  end

  test "create normalizes email (strip + downcase)" do
    sign_in_as(@admin)
    assert_difference -> { @customer.loyalty_account.reload.points_balance }, 1 do
      post admin_points_awards_path, params: {
        email_address: "  #{@customer.email_address.upcase}  ",
        amount_ars: 100
      }
    end
  end

  test "create rejects unknown email" do
    sign_in_as(@admin)
    post admin_points_awards_path, params: { email_address: "nope@example.com", amount_ars: 500 }
    assert_redirected_to new_admin_points_award_path
    assert_equal "Cliente no encontrado.", flash[:alert]
  end

  test "create rejects admin as target" do
    sign_in_as(@admin)
    post admin_points_awards_path, params: { email_address: @admin.email_address, amount_ars: 500 }
    assert_redirected_to new_admin_points_award_path
    assert_equal "Cliente no encontrado.", flash[:alert]
  end

  test "create rejects zero amount" do
    sign_in_as(@admin)
    post admin_points_awards_path, params: { email_address: @customer.email_address, amount_ars: 0 }
    assert_redirected_to new_admin_points_award_path
    assert_equal "Ingresá un monto positivo.", flash[:alert]
  end

  test "create rejects sub-threshold amount that would yield 0 points" do
    sign_in_as(@admin)
    assert_no_difference -> { LoyaltyTransaction.count } do
      post admin_points_awards_path, params: { email_address: @customer.email_address, amount_ars: 50 }
    end
    assert_redirected_to new_admin_points_award_path
    assert_equal "Monto insuficiente para otorgar puntos.", flash[:alert]
  end

  test "create redirects when no active rule" do
    sign_in_as(@admin)
    @rule.update!(active: false)
    post admin_points_awards_path, params: { email_address: @customer.email_address, amount_ars: 500 }
    assert_redirected_to admin_points_conversion_rules_path
  end
end
