module Admin
  class PointsAwardsController < Admin::BaseController
    rate_limit to: 30, within: 3.minutes, only: :create,
               with: -> { redirect_to new_admin_points_award_path, alert: "Probá de nuevo en unos minutos." }

    def new
      @rule = PointsConversionRule.active_rule
      unless @rule
        redirect_to admin_points_conversion_rules_path,
                    alert: "Configurá una regla de conversión activa primero."
      end
    end

    def create
      rule = PointsConversionRule.active_rule
      return redirect_to admin_points_conversion_rules_path, alert: "No hay regla activa." unless rule

      amount_ars = params[:amount_ars].to_i
      return redirect_to new_admin_points_award_path, alert: "Ingresá un monto positivo." unless amount_ars > 0

      email = params[:email_address].to_s.strip.downcase
      user = User.customers.find_by(email_address: email)
      return redirect_to new_admin_points_award_path, alert: "Cliente no encontrado." unless user

      account = user.loyalty_account || user.create_loyalty_account!
      points = amount_ars / rule.pesos_per_point
      if points <= 0
        return redirect_to new_admin_points_award_path, alert: "Monto insuficiente para otorgar puntos."
      end

      account.apply!(
        points: points,
        kind: :earn,
        source: rule,
        note: "Awarded by #{Current.user.email_address}",
        amount_cents: amount_ars * 100
      )

      redirect_to new_admin_points_award_path,
                  notice: "Otorgaste #{points} puntos a #{user.email_address}."
    end
  end
end
