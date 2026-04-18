module Admin
  class PromotionsController < Admin::BaseController
    before_action :set_promotion, only: %i[ show edit update destroy ]

    def index
      @promotions = Promotion.order(created_at: :desc)
    end

    def show
    end

    def new
      @promotion = Promotion.new
    end

    def create
      @promotion = Promotion.new(promotion_params.merge(created_by: Current.user))
      if @promotion.save
        redirect_to admin_promotion_path(@promotion), notice: "Promoción creada."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @promotion.update(promotion_params)
        redirect_to admin_promotion_path(@promotion), notice: "Promoción actualizada."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @promotion.destroy
      redirect_to admin_promotions_path, notice: "Promoción eliminada.", status: :see_other
    end

    private

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      params.require(:promotion).permit(:name, :points_for_redemption, :active, :image, product_ids: [])
    end
  end
end
