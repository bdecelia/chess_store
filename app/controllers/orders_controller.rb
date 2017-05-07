class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
      @orders = Order.chronological.paginate(:page => params[:page]).per_page(7)
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to item_path(@order), notice: "Successfully created #{@order.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      redirect_to order_path(@order), notice: "Successfully updated #{@order.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to order_path, notice: "Successfully removed #{@order.name} from the system."
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:school_id, :user_id)
  end

end
