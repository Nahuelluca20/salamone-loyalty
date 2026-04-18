class LoyaltyAccount < ApplicationRecord
  belongs_to :user
  has_many :loyalty_transactions, dependent: :destroy

  def apply!(points:, kind:, source: nil, note: nil, amount_cents: nil)
    transaction do
      loyalty_transactions.create!(
        points: points, kind: kind, source: source, note: note, amount_cents: amount_cents
      )
      update!(points_balance: points_balance + points)
    end
  end
end
