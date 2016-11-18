class Community < ApplicationRecord
  include HasOwner
  include Toggleable

  PER_PAGE = 10

  toggleable :inclusive, :visible

  belongs_to :user, optional: true
  belongs_to :agent, optional: true

  before_validation { self.name = name.strip unless name.nil? }
  validates_presence_of :name
  validates_uniqueness_of :name

  scope :ordered_by_name, -> { order 'name asc' }
  scope :visible, -> { where deleted: false, visible: true }
  scope :name_like, -> (name) { where 'name ilike ?', "%#{name}%" unless name.blank? }
  scope :filtered, -> (f) { name_like(f[:name]) }

  def self.page_for_administration(page, filter = {})
    filtered(filter).ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(visible inclusive name description)
  end
end
