class News < ApplicationRecord
  include HasOwner
  include Toggleable

  PER_PAGE = 20

  toggleable :visible

  mount_uploader :image, PostImageUploader

  belongs_to :user
  belongs_to :agent, optional: true
  belongs_to :region, optional: true, counter_cache: true
  has_many :site_news, dependent: :destroy
  has_many :news_categories, through: :site_news

  enum post_type: [:news, :comment, :topic]

  before_validation :generate_slug

  validates_presence_of :post_type, :title, :slug, :lead, :body

  scope :popular, -> { order 'view_count desc' }
  scope :in_category, -> (category) { joins(:site_news).where(site_news: { news_category: category }) }
  scope :with_category_ids, -> (ids) { joins(:site_news).where(site_news: { news_category_id: ids} ) }
  scope :of_type, -> (type) { where post_type: News.post_types[type] }
  scope :recent, -> { order 'id desc' }
  scope :visible, -> { where visible: true, deleted: false }
  scope :regional, -> { where 'region_id > 0' }
  scope :federal, -> { where region_id: nil }

  # @param [Integer] page
  def self.page_for_administration(page)
    recent.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page)
    visible.recent.page(page).per(PER_PAGE)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page)
    owned_by(user).where(deleted: false).recent.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(image title lead body post_type slug region_id)
  end

  # @param [NewsCategory] category
  def news_category=(category)
    parameters = { news: self }
    site_news  = SiteNews.find_by parameters
    if site_news.nil?
      SiteNews.create parameters.merge(news_category: category)
    else
      site_news.update news_category: category
    end
  end

  def category
    news_categories.first
  end

  def regional?
    region_id.to_i > 0
  end

  # @param [User] user
  def editable_by?(user)
    !deleted? && !locked? && (owned_by?(user) || UserRole.user_has_role?(user, :chief_editor))
  end

  # @param [User] user
  def commentable_by?(user)
    visible? && !deleted? && user.is_a?(User)
  end

  # @param [User] user
  def visible_to?(user)
    visible? || editable_by?(user)
  end

  private

  def generate_slug
    if slug.blank?
      postfix   = (created_at || Time.now).strftime('%d%m%Y')
      self.slug = "#{Canonizer.transliterate(title.to_s)}_#{postfix}"
    end
  end
end
