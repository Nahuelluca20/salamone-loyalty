class PromotionsController < ApplicationController
  before_action :require_customer!
  layout "shop"

  def index
    @promotions = Promotion.active.order(:points_for_redemption)
  end

  def show
    @promotion = Promotion.active.find(params[:id])
    @products  = @promotion.products.active
  end
end
