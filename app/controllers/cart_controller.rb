class CartController < ApplicationController
  include ChessStoreHelpers::Cart
  include ChessStoreHelpers::Shipping
  before_action :set_cart

  def cart
    redirect_to home_path, notice: "You cannot form a cart." if logged_in? && !current_user.role?(:customer)
    @user_school = session[:school_id].nil? ? nil : School.find(session[:school_id])
    @school = School.new
    set_credit_card
  end

  def add
    add_item_to_cart(target_item)
    redirect_to cart_path
  end

  def remove
    remove_item_from_cart(target_item)
    redirect_to cart_path
  end

  def remove_school
    session[:school_id] = nil
    redirect_to cart_path
  end

  def finalize
    @order = Order.new(finalize_params)
    if @order.save
      save_each_item_in_cart(@order)
      clear_cart
      redirect_to order_path(@order), notice: "Successfully placed an order. Thank you!"
    else
      redirect_to cart_path
    end
  end

  def destroy
    clear_cart
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

  def set_credit_card
    @credit_card = session[:credit_card]
    if @credit_card.nil?
      @credit_card = CreditCard.new(nil,nil,nil)
    else
      @card_params = [@credit_card["number"], @credit_card["expiration_year"], @credit_card["expiration_month"]]
      @credit_card = CreditCard.new(@card_params[0], @card_params[1], @card_params[2])
    end
  end

  def finalize_params
    {school_id: session[:school_id], user_id: current_user.id}
  end
end
