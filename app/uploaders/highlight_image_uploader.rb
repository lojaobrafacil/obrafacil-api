class HighlightImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
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
end
