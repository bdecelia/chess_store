class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    # get info on active items for the big three...
    @boards = Item.active.for_category('boards').alphabetical.paginate(:page => params[:boards]).per_page(5)
    @pieces = Item.active.for_category('pieces').alphabetical.paginate(:page => params[:pieces]).per_page(5)
    @clocks = Item.active.for_category('clocks').alphabetical.paginate(:page => params[:clocks]).per_page(5)
    @supplies = Item.active.for_category('supplies').alphabetical.paginate(:page => params[:supplies]).per_page(5)
    # get a list of any inactive items for sidebar
    @inactive_items = Item.inactive.alphabetical.to_a
  end

  def show
    # get the price history for this item
    @price_history = @item.item_prices.chronological.to_a
    # everyone sees similar items in the sidebar
    @similar_items = Item.for_category(@item.category).active.alphabetical.to_a - [@item]
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to item_path(@item), notice: "Successfully created #{@item.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: "Successfully updated #{@item.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "Successfully removed #{@item.name} from the system."
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :color, :category, :weight, :inventory_level, :reorder_level, :active)
  end

end
