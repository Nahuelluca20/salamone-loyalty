class LoyaltyTransaction < ApplicationRecord
  belongs_to :loyalty_account
  belongs_to :source, polymorphic: true, optional: true

  enum :kind, { earn: 0, redeem: 1, adjustment: 2 }

  validates :points, numericality: { other_than: 0 }
end
