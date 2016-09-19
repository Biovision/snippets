class ItemTypesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /item_types/new
  def new
    @entity = ItemType.new
  end

  # post /item_types
  def create
    @entity = ItemType.new entity_parameters
    if @entity.save
      redirect_to admin_item_type_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /item_types/:id/edit
  def edit
  end

  # patch /item_types/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_item_type_path(@entity), notice: t('item_types.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /item_types/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('item_types.destroy.success')
    end
    redirect_to admin_item_types_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = ItemType.find params[:id]
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_item_type_path(@entity), alert: t('item_types.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:item_type).permit(ItemType.entity_parameters)
  end
end
