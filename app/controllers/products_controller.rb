class ProductsController < ApplicationController
  before_action :require_customer!
  layout "shop"

  def index
    @products = Product.active.order(:name)
  end

  def show
    @product = Product.active.find(params[:id])
    @related_promotions = @product.promotions.where(active: true)
  end
end
