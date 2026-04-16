class CreateLoyaltyAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :loyalty_accounts do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :points_balance, default: 0, null: false

      t.timestamps
    end
  end
end
