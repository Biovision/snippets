class Api::CategoriesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity

  # post /api/categories/:id/toggle
  def toggle
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    end
  end

  # put /api/categories/:id/lock
  def lock
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/categories/:id/lock
  def unlock
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  # post /api/categories/:id/priority
  def priority
    @entity.increment! :priority, params[:delta].to_s.to_i

    render json: { data: { priority: @entity.priority } }
  end

  private

  def set_entity
    @entity = Category.find params[:id]
    raise record_not_found if @entity.deleted?
  end

  def restrict_access
    require_role :administrator
  end
end
