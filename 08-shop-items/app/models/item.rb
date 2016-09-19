class Item < ApplicationRecord
  include Toggleable

  PER_PAGE = 12

  toggleable :visible, :new_arrival, :sale, :exclusive

  belongs_to :brand, optional: true, counter_cache: true
  belongs_to :category, counter_cache: true
  belongs_to :item_type, counter_cache: true

  enum status: [:available, :to_order]

  mount_uploader :image, ItemImageUploader

  validates_presence_of :name, :status
  validates_numericality_of :price, greater_than: 0, allow_nil: true
  validates_numericality_of :old_price, greater_than: 0, allow_nil: true

  after_initialize :set_next_priority
  before_validation :generate_slug, :normalize_price

  scope :ordered_by_priority, -> { order 'priority asc, name asc' }
  scope :visible, -> { where visible: true, deleted: false }

  def self.page_for_administration(page)
    ordered_by_priority.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(
      brand_id category_id item_type_id
      status priority slug image name article description price old_price
      visible new_arrival sale exclusive
    )
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = Item.where(category: category).maximum(:priority).to_i + 1
    end
  end

  def generate_slug
    if slug.blank?
      self.slug = Canonizer.transliterate name.to_s
    end
  end

  def normalize_price
    self.price = nil if price.to_i == 0
    self.old_price = nil if old_price.to_i == 0
  end
end
