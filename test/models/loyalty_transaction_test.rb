require "test_helper"

class LoyaltyTransactionTest < ActiveSupport::TestCase
  test "validates points is not zero" do
    account = loyalty_accounts(:customer_account)
    txn = account.loyalty_transactions.build(points: 0, kind: :earn)

    assert_not txn.valid?
    assert_includes txn.errors[:points], "must be other than 0"
  end
end
