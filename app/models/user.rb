class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :loyalty_account, dependent: :destroy

  enum :role, { customer: 0, admin: 1 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create :create_loyalty_account_if_customer

  private

  def create_loyalty_account_if_customer
    create_loyalty_account! if customer?
  end
end
