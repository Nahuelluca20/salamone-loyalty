class CreateLoyaltyTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :loyalty_transactions do |t|
      t.references :loyalty_account, null: false, foreign_key: true
      t.integer :points, null: false
      t.integer :kind, null: false
      t.string :source_type
      t.bigint :source_id
      t.string :note

      t.timestamps
    end

    add_index :loyalty_transactions, [:loyalty_account_id, :created_at]
    add_index :loyalty_transactions, [:source_type, :source_id]
  end
end
