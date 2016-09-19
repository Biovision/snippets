class BrandsController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /brands/new
  def new
    @entity = Brand.new
  end

  # post /brands
  def create
    @entity = Brand.new entity_parameters
    if @entity.save
      redirect_to admin_brand_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /brands/:id/edit
  def edit
  end

  # patch /brands/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_brand_path(@entity), notice: t('brands.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /brands/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('brands.destroy.success')
    end
    redirect_to admin_brands_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Brand.find params[:id]
    raise record_not_found if @entity.deleted?
  end

  def restrict_editing
    if @entity.locked?
      redirect_to admin_brand_path(@entity), alert: t('brands.edit.forbidden')
    end
  end

  def entity_parameters
    params.require(:brand).permit(Brand.entity_parameters)
  end
end
