class Admin::CategoriesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/categories
  def index
    @collection = Category.for_tree
  end

  # get /admin/categories/:id
  def show
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Category.find params[:id]
    raise record_not_found if @entity.deleted?
  end
end
