class Admin::RegionsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, except: [:index]

  # get /admin/regions
  def index
    @collection = Region.page_for_administration
  end

  # get /admin/regions/:id
  def show
  end

  private

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Region.find params[:id]
  end
end
