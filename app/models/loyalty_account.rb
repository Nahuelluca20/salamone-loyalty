class LoyaltyAccount < ApplicationRecord
  belongs_to :user
  has_many :loyalty_transactions, dependent: :destroy

  def apply!(points:, kind:, source: nil, note: nil)
    transaction do
      loyalty_transactions.create!(points: points, kind: kind, source: source, note: note)
      update!(points_balance: points_balance + points)
    end
  end
end
