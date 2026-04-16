module Authorization
  extend ActiveSupport::Concern

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized." unless Current.user&.admin?
  end

  def require_customer!
    redirect_to root_path, alert: "Not authorized." unless Current.user&.customer?
  end
end
