class NewsController < ApplicationController
  before_action :restrict_access, only: [:new, :create]
  before_action :set_entity, only: [:edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /news
  # get /novosti
  def index
    @collection = News.federal.page_for_visitors current_page
  end

  # get /news/:category_slug
  # get /novosti/:category_slug
  def category
    @category   = NewsCategory.find_by! slug: params[:category_slug]
    @collection = News.of_type(:news).in_category(@category).page_for_visitors(current_page)
  end

  # get /news/new
  def new
    @entity = News.new
  end

  # post /news
  def create
    @entity = News.new creation_parameters
    if @entity.save
      redirect_to admin_news_path(@entity)
    else
      render :new, status: :bad_request
    end
  end

  # get /news/:category_slug/:slug
  # get /novosti/:category_slug/:slug
  def show
    @category = NewsCategory.find_by! slug: params[:category_slug]
    @entity   = News.find_by! slug: params[:slug]
    raise record_not_found unless @entity.visible_to?(current_user) && @category.has_news?(@entity)
    @entity.increment! :view_count
  end

  # get /news/:id/edit
  def edit
  end

  # patch /news/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_news_path(@entity), notice: t('news.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /news/:id
  def destroy
    if @entity.update(deleted: true)
      flash[:notice] = t('news.destroy.success')
    end
    redirect_to admin_news_index_path
  end

  private

  def set_entity
    @entity = News.find params[:id]
  end

  def restrict_access
    require_role :chief_editor, :editor
  end

  def restrict_editing
    raise record_not_found unless @entity.editable_by? current_user
  end

  def entity_parameters
    params.require(:news).permit(News.entity_parameters)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end
end
