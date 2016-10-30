class NewsCategory < ApplicationRecord
  include Toggleable

  METRIC_COUNT = 'news_categories.count'

  toggleable :visible

  has_many :site_news, dependent: :destroy

  validates_presence_of :name, :slug, :priority
  validates_uniqueness_of :name
  validates_uniqueness_of :slug

  after_initialize :set_next_priority
  before_validation :generate_slug

  scope :ordered_by_priority, -> { order 'priority asc' }
  scope :visible, -> { where visible: true, deleted: false }

  def self.page_for_administration
    ordered_by_priority
  end

  def self.page_for_visitors
    visible.ordered_by_priority
  end

  def self.entity_parameters
    %i(name slug priority visible)
  end

  # @param [News] news
  def has_news?(news)
    site_news.exists?(news: news)
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = NewsCategory.maximum(:priority).to_i + 1
    end
  end

  def generate_slug
    if slug.blank?
      self.slug = Canonizer.transliterate name.to_s
    end
  end
end
