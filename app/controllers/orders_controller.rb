class OrdersController < ApplicationController
  before_action :set_order, only: [:show]
  before_action :authenticate_user!
  
  def new
    @order = Order.new
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.save
      redirect_to @order, notice: 'Pedido registrado com sucesso.'
    end
  end

  def show; end

  private

  def order_params
    params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
  end

  def set_order
    @order = Order.find(params[:id])
  end
end