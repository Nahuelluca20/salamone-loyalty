class PointsConversionRule < ApplicationRecord
  belongs_to :created_by, class_name: "User", optional: true

  validates :pesos_per_point, numericality: { only_integer: true, greater_than: 0 }

  scope :active_scope, -> { where(active: true) }

  before_save :deactivate_other_active_rules

  def self.active_rule
    active_scope.order(created_at: :desc).first
  end

  private

  def deactivate_other_active_rules
    return unless active?
    self.class.active_scope.where.not(id: id).update_all(active: false, updated_at: Time.current)
  end
end
