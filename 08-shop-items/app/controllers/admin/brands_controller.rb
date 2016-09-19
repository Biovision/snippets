class Admin::BrandsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/brands
  def index
    @collection = Brand.page_for_administration current_page
  end

  # get /admin/brands/:id
  def show
  end

  # get /admin/brands/:id/items
  def items
    @collection = @entity.items.page_for_administration current_page
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Brand.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
