class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @shipped_orders = Order.joins(:order_items).where("order_items.shipped_on IS NOT NULL").chronological.uniq!.paginate(:page => params[:shipped]).per_page(7)
    @unshipped_orders = Order.not_shipped.paginate(:page => params[:unshipped]).per_page(7)
    @personal_orders = logged_in? ? Order.where(user_id: current_user.id).paginate(:page => params[:personal]).per_page(7) : nil
  end

  def show
    @order_items = @order.order_items.to_a
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

  def ship
    @order_item = OrderItem.find(params[:order_item_id])
    @order_item.update_attribute(:shipped_on, Date.current)
    @order_item.save
    respond_to do |format|
      format.js {}
     end
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:school_id, :user_id)
  end

end
