class Comment < ActiveRecord::Base
  include HasOwner

  PER_PAGE = 20

  belongs_to :commentable, polymorphic: true, counter_cache: true, touch: false

  validates_presence_of :user_id, :commentable, :body
  validate :commentable_is_visible

  scope :recent, -> { order 'id desc' }
  scope :visible, -> { where deleted: false }

  # @param [Integer] page
  def self.page_for_administration(page)
    recent.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitor(page)
    recent.visible.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(commentable_id commentable_type body)
  end

  def self.administrative_parameters
    entity_parameters + %i(deleted)
  end

  def notify_entry_owner?
    entry_owner = commentable.user
    if entry_owner.is_a?(User) && !owned_by?(entry_owner)
      entry_owner.can_receive_letters?
    else
      false
    end
  end

  private

  def commentable_is_visible
    if self.commentable.respond_to? :visible_to?
      unless self.commentable.visible_to? self.user
        errors.add(:commentable, I18n.t('activerecord.errors.models.comment.attributes.commentable.not_commentable'))
      end
    end
  end
end
