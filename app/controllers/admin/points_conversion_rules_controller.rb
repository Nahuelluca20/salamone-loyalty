module Admin
  class PointsConversionRulesController < Admin::BaseController
    before_action :set_rule, only: %i[ edit update destroy ]

    def index
      @rules = PointsConversionRule.order(active: :desc, created_at: :desc)
    end

    def new
      @rule = PointsConversionRule.new
    end

    def create
      @rule = PointsConversionRule.new(rule_params.merge(created_by: Current.user))
      if @rule.save
        redirect_to admin_points_conversion_rules_path, notice: "Regla creada."
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      @rule.errors.add(:base, "Otro admin activó una regla al mismo tiempo. Refrescá y probá de nuevo.")
      render :new, status: :unprocessable_entity
    end

    def edit
    end

    def update
      if @rule.update(rule_params)
        redirect_to admin_points_conversion_rules_path, notice: "Regla actualizada."
      else
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      @rule.errors.add(:base, "Otro admin activó una regla al mismo tiempo. Refrescá y probá de nuevo.")
      render :edit, status: :unprocessable_entity
    end

    def destroy
      @rule.destroy
      redirect_to admin_points_conversion_rules_path, notice: "Regla eliminada.", status: :see_other
    end

    private

    def set_rule
      @rule = PointsConversionRule.find(params[:id])
    end

    def rule_params
      params.require(:points_conversion_rule).permit(:pesos_per_point, :active)
    end
  end
end
