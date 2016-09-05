class Category < ApplicationRecord
  include Toggleable

  PER_PAGE = 20

  toggleable :visible

  belongs_to :parent, class_name: Category.to_s
  has_many :children, class_name: Category.to_s, foreign_key: :parent_id

  validates_presence_of :name, :priority
  validates_uniqueness_of :name, scope: [:parent_id]

  after_initialize :set_next_priority
  before_save :compact_children_cache

  scope :ordered_by_priority, -> { order 'priority asc, name asc' }
  scope :visible, -> { where visible: true }
  scope :for_tree, -> (parent_id = nil) { where(parent_id: parent_id).ordered_by_priority }

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

  def parents
    if parents_cache.blank?
      []
    else
      Category.where(id: parents_cache.split(',').compact).order('id asc')
    end
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
    children.order('id asc').map { |child| self.children_cache += [child.id] + child.children_cache }
    save!
    parent.cache_children! unless parent.nil?
  end

  def can_be_deleted?
    children.count < 1
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = Category.where(parent_id: parent_id).maximum(:priority).to_i + 1
    end
  end

  def compact_children_cache
    self.children_cache.uniq!
  end
end
