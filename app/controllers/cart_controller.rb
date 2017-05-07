class CartController < ApplicationController
  include ChessStoreHelpers::Cart
  include ChessStoreHelpers::Shipping
  before_action :set_cart

  def cart
  end

  def add
    add_item_to_cart(target_item)
    redirect_to cart_path
  end

  def remove
    remove_item_from_cart(target_item)
    redirect_to cart_path
  end

  def checkout
    @credit_card = nil
  end

  def finalize
    order = Order.new(user_id: current_user, school_id: params[:school_id])
    save_each_item_in_cart(order.id) if order.save
    redirect_to home_path
  end

  def destroy
  end

  private
  def set_cart
    create_cart
    @order_items = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping = calculate_cart_shipping
    @grand_total = @subtotal + @shipping
  end

  def target_item
    item_id = params[:item_id]
  end
end
