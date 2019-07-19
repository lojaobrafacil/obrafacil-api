class HighlightImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    "#{Devise.friendly_token(30)}.#{file.extension}" if original_filename.present?
  end
end
