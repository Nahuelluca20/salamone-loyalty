class AddAmountCentsToLoyaltyTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :loyalty_transactions, :amount_cents, :integer
  end
end
