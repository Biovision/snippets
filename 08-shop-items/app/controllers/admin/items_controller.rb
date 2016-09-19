class Admin::ItemsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/items
  def index
    @collection = Item.page_for_administration current_page
  end

  # get /admin/items/:id
  def show
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Item.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
