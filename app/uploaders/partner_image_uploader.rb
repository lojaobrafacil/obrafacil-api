class PartnerImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws
  process :resize_to_limit => [1024, 1024]

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    "project_image.#{file.extension}" if original_filename.present?
  end
end
