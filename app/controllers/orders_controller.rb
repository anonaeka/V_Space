class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # sales history page
  def sales
    @orders = Order.all.where(seller: current_user).order("created_at DESC")
  end
  # purchases history page
  def purchases
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end

  # GET /orders/new
  def new
    @order = Order.new
    @product = Product.find(params[:product_id])
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @product = Product.find(params[:product_id])
    @seller = @product.user

    @order.product_id = @product.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id

    respond_to do |format|
      if @order.save
        format.html { redirect_to products_url, notice: "Order was successfully." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:address, :city, :state)
    end
end
