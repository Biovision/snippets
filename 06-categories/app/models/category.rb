class Category < ApplicationRecord
  include Toggleable

  toggleable :visible

  belongs_to :parent, class_name: Category.to_s, optional: true
  has_many :children, class_name: Category.to_s, foreign_key: :parent_id, dependent: :destroy

  validates_presence_of :name, :priority
  validates_uniqueness_of :name, scope: [:parent_id]
  validates_uniqueness_of :slug

  after_initialize :set_next_priority
  before_validation { self.name = name.strip unless name.nil? }
  before_validation :generate_slug
  before_save :compact_children_cache

  scope :ordered_by_priority, -> { order 'parent_id, priority asc, name asc' }
  scope :visible, -> { where visible: true, deleted: false }
  scope :for_tree, -> (parent_id = nil) { where(parent_id: parent_id).ordered_by_priority }

  def self.entity_parameters
    %i(name priority slug)
  end

  def self.creation_parameters
    entity_parameters + %i(parent_id)
  end

  def full_title
    (parents.map { |parent| parent.name } + [name]).join ' / '
  end

  def ids
    [id] + children_cache
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
    !locked? && children.count < 1
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    adjacent     = Category.find_by(parent_id: parent_id, priority: new_priority)
    if adjacent.is_a?(Category) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    self.update(priority: new_priority)

    Category.where(parent_id: parent_id).ordered_by_priority.map { |a| [a.id, a.priority] }.to_h
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = Category.where(parent_id: parent_id).maximum(:priority).to_i + 1
    end
  end

  def generate_slug
    if slug.blank?
      self.slug = Canonizer.transliterate name.to_s
    end
  end

  def compact_children_cache
    self.children_cache.uniq!
  end
end
