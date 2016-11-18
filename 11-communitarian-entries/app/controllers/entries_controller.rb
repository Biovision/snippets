class EntriesController < ApplicationController
  before_action :restrict_anonymous_access, except: [:index, :show]
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :restrict_editing, only: [:edit, :update, :destroy]

  # get /entries
  def index
    @collection = Entry.page_for_visitors(current_user, current_page)
  end

  # get /entries/new
  def new
    @entity = Entry.new
  end

  # post /entries
  def create
    @entity = Entry.new creation_parameters
    if @entity.save
      redirect_to @entity
    else
      render :new, status: :bad_request
    end
  end

  # get /entries/:id
  def show
    raise record_not_found unless @entity.visible_to? current_user
    set_adjacent_entities
  end

  # get /entries/:id/edit
  def edit
  end

  # patch /entries/:id
  def update
    if @entity.update entity_parameters
      redirect_to @entity, notice: t('entries.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  # delete /entries/:id
  def destroy
    if @entity.update(deleted: true)
      flash[:notice] = t('entries.destroy.success')
    end

    redirect_to entries_path
  end

  # get /entries/archive/(:year)/(:month)
  def archive
    collect_months
    unless params[:month].nil?
      @collection = Entry.archive(params[:year], params[:month]).page_for_visitors current_user, current_page
    end
  end

  private

  def set_entity
    @entity = Entry.find params[:id]
  end

  def restrict_editing
    raise record_not_found unless @entity.editable_by? current_user
  end

  def creation_parameters
    entry_parameters = params.require(:entry).permit(Entry.creation_parameters)
    entry_parameters.merge(owner_for_entity).merge(tracking_for_entity)
  end

  def entity_parameters
    params.require(:entry).permit(Entry.entity_parameters)
  end

  def collect_months
    @dates = Hash.new
    Entry.not_deleted.distinct.pluck("date_trunc('month', created_at)").sort.each do |date|
      @dates[date.year] = [] unless @dates.has_key? date.year
      @dates[date.year] << date.month
    end
  end

  def set_adjacent_entities
    privacy   = Entry.privacy_for_user(current_user)
    @adjacent = {
        prev: Entry.with_privacy(privacy).where('id < ?', @entity.id).order('id desc').first,
        next: Entry.with_privacy(privacy).where('id > ?', @entity.id).order('id asc').first
    }
  end
end
