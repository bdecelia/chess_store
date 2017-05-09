class HomeController < ApplicationController
  def home
    @popular_items = Item.joins("INNER JOIN items ON items.id = O.item_id").from(OrderItem.select("item_id, COUNT(item_id) as count").group("item_id").order("count DESC").limit(10),:O).paginate(:page => params[:page]).per_page(10)
    @unshipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
    @items_to_reorder = Item.need_reorder.alphabetical.paginate(:page => params[:page]).per_page(10)
    @previously_bought = Item.where(:id => OrderItem.where(:order_id => Order.where(user_id: current_user.id).select("id")).select("item_id")).paginate(:page => params[:page]).per_page(10) if current_user
  end

  def about
  end

  def contact
  end

  def privacy
  end

end
