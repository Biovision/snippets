class Api::CartController < ApplicationController
  include OrderInSession

  before_action :order_from_session

  # get /api/cart
  def show
    head :no_content if @order.nil?
  end

  # post /api/cart/items
  def add_item
    item     = Item.find params[:item_id]
    quantity = (params[:quantity] || '1').to_s.to_i.abs
    create_order if @order.nil?
    @order.add_item(item, quantity)
    render :show
  end

  # delete /api/cart/items/:id
  def remove_item
    item     = Item.find_by(id: params[:id])
    quantity = (params[:quantity] || '1').to_s.to_i.abs
    if @order.is_a?(Order) && item.is_a?(Item)
      @order.remove_item(item, quantity)
      render :show
    else
      head :no_content
    end
  end
end
