class SitePost < ApplicationRecord
  belongs_to :post
  belongs_to :post_category, counter_cache: :items_count

  validates_uniqueness_of :post
  # validate :category_has_parent

  private

  def category_has_parent
    if post_category&.parent.blank?
      errors.add(:post_category, I18n.t('activerecord.errors.models.site_post.attributes.category.is_top_level'))
    end
  end
end
