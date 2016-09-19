class ItemsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /items/new
  def new
    @entity = Item.new
  end

  # post /items
  def create
    @entity = Item.new entity_parameters
    if @entity.save
      redirect_to admin_item_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /items/:id/edit
  def edit
  end

  # patch /items/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_item_path(@entity), notice: t('items.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /items/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('items.destroy.success')
    end
    redirect_to admin_items_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Item.find params[:id]
    raise record_not_found if @entity.deleted?
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_item_path(@entity), alert: t('items.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:item).permit(Item.entity_parameters)
  end
end
