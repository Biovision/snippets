class PostsController < ApplicationController
  before_action :restrict_access, only: [:new, :create]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /posts
  def index
    @collection = Post.page_for_visitors current_page
  end

  # get /posts/new
  def new
    @entity = Post.new
  end

  # post /posts
  def create
    @entity = Post.new creation_parameters
    if @entity.save
      set_dependent_entities
      redirect_to @entity
    else
      render :new, status: :bad_request
    end
  end

  # get /posts/:id
  def show
    raise record_not_found unless @entity.visible_to? current_user
  end

  # get /posts/:id/edit
  def edit
  end

  # patch /posts/:id
  def update
    if @entity.update entity_parameters
      set_dependent_entities
      redirect_to @entity, notice: t('posts.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /posts/:id
  def destroy
    if @entity.update(deleted: true)
      flash[:notice] = t('posts.destroy.success')
    end
    redirect_to admin_posts_path
  end

  # get /posts/tagged/:tag_name
  def tagged
    set_tag
    @collection = Post.tagged(@tag).page_for_visitors(current_page)
  end

  # get /posts/archive/(:year)/(:month)
  def archive
    collect_months
    @collection = Post.archive(params[:year], params[:month]).page_for_visitors current_page unless params[:month].nil?
  end

  private

  def set_entity
    @entity = Post.find params[:id]
  end

  def set_tag
    @tag = Tag.match_by_name! params[:tag_name]
  end

  def collect_months
    @dates = Hash.new
    Post.visible.distinct.pluck("date_trunc('month', created_at)").sort.each do |date|
      @dates[date.year] = [] unless @dates.has_key? date.year
      @dates[date.year] << date.month
    end
  end

  def restrict_access
    require_role :chief_editor, :editor
  end

  def restrict_editing
    raise record_not_found unless @entity.editable_by? current_user
  end

  def entity_parameters
    params.require(:post).permit(Post.entity_parameters)
  end

  def creation_parameters
    entity_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end

  def set_dependent_entities
    @entity.tag_ids = params[:tag_ids]
    @entity.cache_tags!
    add_figures unless params[:figures].blank?
  end

  def add_figures
    params[:figures].values.reject { |f| f[:slug].blank? || f[:image].blank? }.each do |data|
      @entity.figures.create(data.select { |key, _| Figure.creation_parameters.include? key } )
    end
  end
end
