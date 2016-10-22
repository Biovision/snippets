class Admin::OrdersController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/orders
  def index
    @collection = Order.page_for_administration current_page
  end

  # get /admin/orders/:id
  def show
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Order.find params[:id]
  end
end
