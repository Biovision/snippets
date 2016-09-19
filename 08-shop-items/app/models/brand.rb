class Brand < ApplicationRecord
  include RequiredUniqueName
  include Toggleable

  PER_PAGE = 20

  toggleable :visible

  has_many :items, dependent: :nullify
  
  mount_uploader :image, BrandImageUploader

  validates_uniqueness_of :slug

  after_initialize :set_next_priority
  before_validation :generate_slug

  scope :ordered_by_priority, -> { order 'priority asc, name asc' }
  scope :visible, -> { where visible: true, deleted: false }

  def self.page_for_administration(page)
    ordered_by_priority.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(priority slug visible image name description)
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = Brand.maximum(:priority).to_i + 1
    end
  end

  def generate_slug
    if slug.blank?
      self.slug = Canonizer.transliterate name.to_s
    end
  end
end
