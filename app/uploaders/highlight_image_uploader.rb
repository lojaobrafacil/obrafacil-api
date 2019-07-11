class HighlightImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
