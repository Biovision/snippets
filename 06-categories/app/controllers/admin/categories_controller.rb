class Admin::CategoriesController < ApplicationController
  before_action :restrict_access

  # get /admin/categories
  def index
    @collection = Category.where(parent_id: nil).page_for_administration(current_page)
  end

  private

  def restrict_access
    require_role :administrator
  end
end
