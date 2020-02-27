class ProjectImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws
  process :resize_to_limit => [1024, 1024]

  def store_dir
    "#{model.class.to_s.underscore}/#{model.metadata ? model.metadata : model.id}"
  end
end
