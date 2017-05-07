class CartController < ApplicationController
  include ChessStoreHelpers::Cart
  def cart
    create_cart
    @cart = session[:cart].to_a
    @cart.each do |cart_item|
      item_obj = Item.find_by(cart_item[0])
      cart_item[0] = item_obj
    end
  end

  def add
    create_cart
    item_id = params[:id]
    add_item_to_cart(item_id)
    redirect_to cart_path
  end
end
