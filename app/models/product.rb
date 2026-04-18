class Product < ApplicationRecord
  belongs_to :created_by, class_name: "User", optional: true
  has_many :promotion_products, dependent: :destroy
  has_many :promotions, through: :promotion_products
  has_one_attached :image

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
