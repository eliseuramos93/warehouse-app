class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:show, :edit, :update, :delivered, :canceled]
  

  def index 
    @orders = current_user.orders
  end
  
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
    else
      set_suppliers_and_warehouses
      flash.now[:notice] = 'Não foi possível registrar o pedido.'
      render 'new'
    end
  end

  def show; end

  def search
    @code = params[:query]
    @orders = Order.where("code LIKE ?", "%#{@code}%")
  end

  def edit
    set_suppliers_and_warehouses
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Pedido atualizado com sucesso.'
    else
      set_suppliers_and_warehouses
      flash.now[:notice] = 'Não foi possível atualizar o pedido.'
      render 'edit'
    end
  end

  def delivered
    @order.delivered!
    redirect_to @order
  end

  def canceled
    @order.canceled!
    redirect_to @order
  end

  private

  def order_params
    params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
  end

  def check_user
    @order = Order.find(params[:id])
    if @order.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a este pedido.'
    end
  end

  def set_suppliers_and_warehouses
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

end