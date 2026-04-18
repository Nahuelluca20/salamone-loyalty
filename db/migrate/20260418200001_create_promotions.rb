class CreatePromotions < ActiveRecord::Migration[8.1]
  def change
    create_table :promotions do |t|
      t.string :name, null: false
      t.integer :points_for_redemption, null: false
      t.boolean :active, null: false, default: true
      t.references :created_by, foreign_key: { to_table: :users, on_delete: :nullify }

      t.timestamps
    end

    add_index :promotions, :active
  end
end
