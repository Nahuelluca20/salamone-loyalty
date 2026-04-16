require "test_helper"

class LoyaltyAccountTest < ActiveSupport::TestCase
  setup { @account = loyalty_accounts(:customer_account) }

  test "apply! earn increases balance and creates transaction" do
    @account.apply!(points: 100, kind: :earn)

    assert_equal 100, @account.reload.points_balance
    assert_equal 1, @account.loyalty_transactions.count
    assert @account.loyalty_transactions.last.earn?
  end

  test "apply! redeem decreases balance and creates transaction" do
    @account.update!(points_balance: 100)
    @account.apply!(points: -30, kind: :redeem)

    assert_equal 70, @account.reload.points_balance
    assert @account.loyalty_transactions.last.redeem?
  end

  test "apply! is atomic — failed transaction rolls back balance" do
    assert_no_changes -> { @account.reload.points_balance } do
      assert_raises(ActiveRecord::RecordInvalid) do
        @account.apply!(points: 0, kind: :earn)
      end
    end
    assert_equal 0, @account.loyalty_transactions.count
  end
end
