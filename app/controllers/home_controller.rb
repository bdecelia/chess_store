class HomeController < ApplicationController
  def home
    @popular_items = Item.joins("INNER JOIN items ON items.id = O.item_id").from(OrderItem.select("item_id, COUNT(item_id) as count").group("item_id").order("count DESC").limit(10),:O)
    @unshipped_orders = Order.not_shipped.chronological.to_a
    @items_to_reorder = Item.need_reorder.alphabetical.to_a
    @previously_bought = Item.where(:id => OrderItem.where(:order_id => Order.where(user_id: current_user.id).select("id")).select("item_id")).to_a if current_user
  end

  def about
  end

  def contact
  end

  def privacy
  end

end
