class Post < ApplicationRecord
  include HasOwner
  include Toggleable

  PER_PAGE    = 5
  TITLE_LIMIT = 200
  LEAD_LIMIT  = 500

  toggleable :visible

  belongs_to :user
  belongs_to :agent, optional: true
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates_presence_of :title, :lead, :body
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :lead, maximum: LEAD_LIMIT

  before_validation :generate_slug

  mount_uploader :image, PostImageUploader

  scope :recent, -> { order 'id desc' }
  scope :visible, -> { where(deleted: false, visible: true) }
  scope :tagged, -> (tag) { joins(:post_tags).where(post_tags: { tag: tag }) }
  scope :archive, -> (year, month) { where "date_trunc('month', created_at) = ?", '%04d-%02d-01' % [year, month] }

  # @param [Integer] page
  def self.page_for_administration(page)
    recent.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page)
    visible.recent.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(image title lead body)
  end

  # @param [String] tags_string
  def tags_string=(tags_string)
    list_of_tags = []
    tags_string.split(/,\s*/).reject { |tag_name| tag_name.blank? }.each do |tag_name|
      list_of_tags << Tag.match_or_create_by_name(tag_name.squish)
    end
    self.tags = list_of_tags.uniq
  end

  def cache_tags!
    update! tags_cache: tags.order('slug asc').map { |tag| tag.name }
  end

  # @param [User] user
  def editable_by?(user)
    owned_by?(user) || UserRole.user_has_role?(user, :chief_editor)
  end

  # @param [User] user
  def commentable_by?(user)
    user.is_a? User
  end

  private

  def generate_slug
    self.slug = Canonizer.transliterate self.title.to_s
  end
end