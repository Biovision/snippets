class Api::CategoriesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:toggle]

  # post /api/categories/:id/toggle
  def toggle
    render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
  end

  private

  def set_entity
    @entity = Category.find params[:id]
  end

  def restrict_access
    require_role :administrator
  end
end
