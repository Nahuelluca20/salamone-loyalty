module Admin
  class ProductsController < Admin::BaseController
    before_action :set_product, only: %i[ show edit update destroy ]

    def index
      @status = params[:status].presence_in(%w[ active inactive all ]) || "active"
      @products = case @status
      when "inactive" then Product.inactive
      when "all"      then Product.all
      else                 Product.active
      end.order(created_at: :desc)
    end

    def show
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params.merge(created_by: Current.user))
      if @product.save
        redirect_to admin_product_path(@product), notice: "Producto creado."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        redirect_to admin_product_path(@product), notice: "Producto actualizado."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: "Producto eliminado.", status: :see_other
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :active, :image)
    end
  end
end
