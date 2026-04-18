class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.boolean :active, null: false, default: true
      t.references :created_by, foreign_key: { to_table: :users, on_delete: :nullify }

      t.timestamps
    end

    add_index :products, :active
    add_index :products, :name
  end
end
