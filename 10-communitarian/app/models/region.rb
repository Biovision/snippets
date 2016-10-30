class Region < ApplicationRecord
  SLUG_PATTERN = /\A[a-z0-9](?:[a-z0-9\-]{0,61}[a-z0-9])?\z/

  has_many :news, dependent: :nullify
  has_many :users, dependent: :nullify

  before_validation :normalize_slug

  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug
  validates_format_of :slug, with: SLUG_PATTERN

  scope :ordered_by_slug, -> { order 'slug asc' }

  def self.page_for_administration
    ordered_by_slug
  end

  def self.entity_parameters
    %i(name slug image)
  end

  private

  def normalize_slug
    self.slug = slug.to_s.downcase
  end
end
