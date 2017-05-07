class CartController < ApplicationController
  include ChessStoreHelpers::Cart
  before_action :set_cart

  def cart
    session[:cart].to_a.each do |cart_item|
      item_obj = Item.find_by(cart_item[0])
      cart_item[0] = item_obj
    end
  end

  def add
    add_item_to_cart(target_item)
    redirect_to cart_path
  end

  def remove
    remove_item_from_cart(target_item)
    redirect_to cart_path
  end

  def calculate
    @total = calculate_cart_items_cost
  end

  def finalize
    order = params[:id]
    save_each_item_in_cart(order)
  end

  def destroy
  end

  private

  def set_cart
    create_cart
  end

  def target_item
    item_id = params[:id]
  end
end
