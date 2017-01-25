class Site < ApplicationRecord
  mount_uploader :image, SiteImageUploader

  def self.synchronization_parameters
    ignored = %w(id)
    column_names.reject { |c| ignored.include?(c) }
  end
end
