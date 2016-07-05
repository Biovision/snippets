class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::BombShelter

  def max_pixel_dimensions
    [1920, 1920]
  end

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/10000.floor}/#{model.id/100.floor}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path('fallback/avatar/' + [version_name, 'default.png'].compact.join('_'))
  end

  resize_to_fit 480, 480

  version :profile do
    resize_to_fit 320, 320
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end