class AddDescriptionToPromotions < ActiveRecord::Migration[8.1]
  def change
    add_column :promotions, :description, :text
  end
end
