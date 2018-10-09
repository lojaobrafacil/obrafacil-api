class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  if Rails.env.production?
    storage :aws 
  else 
    storage :file
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [200, 200]
  end

  version :small do
    process resize_to_fill: [350, 350]
  end

  version :medium do
    process resize_to_fill: [600, 600]
  end

  version :large do
    process resize_to_fill: [1200, 1200]
  end
end
