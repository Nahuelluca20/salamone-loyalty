class CreatePointsConversionRules < ActiveRecord::Migration[8.1]
  def change
    create_table :points_conversion_rules do |t|
      t.integer :pesos_per_point, null: false
      t.boolean :active, null: false, default: false
      t.references :created_by, foreign_key: { to_table: :users, on_delete: :nullify }

      t.timestamps
    end

    add_index :points_conversion_rules, :active,
              unique: true,
              where: "active IS TRUE",
              name: "index_points_conversion_rules_one_active"
  end
end
