class SiteNews < ApplicationRecord
  belongs_to :news
  belongs_to :news_category, counter_cache: :items_count

  validates_uniqueness_of :news
end
