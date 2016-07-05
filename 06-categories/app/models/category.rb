class Category < ActiveRecord::Base
  PER_PAGE = 20

  belongs_to :parent, class_name: Category.to_s
  has_many :children, class_name: Category.to_s, foreign_key: :parent_id
  has_many :items, dependent: :nullify

  validates_presence_of :name, :priority
  validates_uniqueness_of :name, scope: [:parent_id]

  after_initialize :set_next_priority
  before_save :compact_children_cache

  scope :ordered_by_priority, -> { order 'priority asc, name asc' }

  # @param [Integer] page
  def self.page_for_administration(page)
    ordered_by_priority.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(name priority)
  end

  def self.creation_parameters
    entity_parameters + %i(parent_id)
  end

  def cache_parents!
    if parent.nil?
      self.parents_cache = ''
    else
      self.parents_cache = parent.parents_cache + ",#{parent_id}"
    end
    save!
  end

  def cache_children!
    self.children.order('id asc').map { |child| self.children_cache += [child.id] + child.children_cache }
    save!
    self.parent.cache_children! unless self.parent.nil?
  end

  def can_be_deleted?
    children.count < 1
  end

  private

  def set_next_priority
    if self.id.nil? && self.priority == 1
      self.priority = Category.where(parent_id: self.parent_id).maximum(:priority).to_i + 1
    end
  end

  def compact_children_cache
    self.children_cache.uniq!
  end
end
