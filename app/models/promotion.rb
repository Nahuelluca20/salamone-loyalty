class Promotion < ApplicationRecord
  belongs_to :created_by, class_name: "User", optional: true
  has_many :promotion_products, dependent: :destroy
  has_many :products, through: :promotion_products
  has_one_attached :image

  validates :name, presence: true
  validates :points_for_redemption, numericality: { only_integer: true, greater_than: 0 }

  scope :active, -> { where(active: true) }
end
