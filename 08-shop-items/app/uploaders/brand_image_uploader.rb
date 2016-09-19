class BrandImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/10000.floor}/#{model.id/100.floor}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path('fallback/brand/default.png')
  end

  version :large do
    resize_to_fit 480, 480
  end

  version :medium, from_version: :large do
    resize_to_fit 240, 240
  end

  version :small, from_version: :medium do
    resize_to_fit 120, 120
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end
