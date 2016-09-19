class Admin::ItemTypesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/item_types
  def index
    @collection = ItemType.page_for_administration
  end

  # get /admin/item_types/:id
  def show
  end
  
  # get /admin/item_types/:id/items
  def items
    @collection = @entity.items.page_for_administration current_page
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = ItemType.find params[:id]
  end
end
