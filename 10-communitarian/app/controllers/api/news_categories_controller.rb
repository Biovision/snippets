class Api::NewsCategoriesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity

  # post /api/news_categories/:id/toggle
  def toggle
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    else
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    end
  end

  # put /api/news_categories/:id/lock
  def lock
    @entity.update! locked: true

    render json: { data: { locked: @entity.locked? } }
  end

  # delete /api/news_categories/:id/lock
  def unlock
    @entity.update! locked: false

    render json: { data: { locked: @entity.locked? } }
  end

  # post /api/news_categories/:id/priority
  def priority
    @entity.increment! :priority, params[:delta].to_s.to_i

    render json: { data: { priority: @entity.priority } }
  end

  private

  def set_entity
    @entity = NewsCategory.find params[:id]
    raise record_not_found if @entity.deleted?
  end

  def restrict_access
    require_role :administrator
  end
end
