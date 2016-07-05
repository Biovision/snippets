class CategoriesController < ApplicationController
  before_action :restrict_access
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  # get /categories/new
  def new
    @entity = Category.new
  end

  # post /categories
  def create
    @entity = Category.new creation_parameters
    if @entity.save
      cache_relatives
      redirect_to @entity
    else
      render :new
    end
  end

  # get /categories/:id
  def show
  end

  # get /categories/:id/edit
  def edit
  end

  # patch /categories/:id
  def update
    if @entity.update entity_parameters
      cache_relatives
      redirect_to @entity, notice: t('categories.update.success')
    else
      render :edit
    end
  end

  # delete /categories/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('categories.destroy.success')
    end
    redirect_to admin_categories_path
  end

  protected

  def restrict_access
    require_role :administrator
  end

  def set_entity
    @entity = Category.find params[:id]
  end

  def entity_parameters
    params.require(:category).permit(Category.entity_parameters)
  end

  def creation_parameters
    params.require(:category).permit(Category.creation_parameters)
  end

  def cache_relatives
    @entity.cache_parents!
    unless @entity.parent.blank?
      parent = @entity.parent
      parent.cache_children!
      parent.save
    end
  end
end
