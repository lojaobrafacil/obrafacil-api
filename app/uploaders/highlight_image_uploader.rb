class HighlightImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    "#{Digest::MD5.hexdigest(self.model.title_1)}.#{file.extension}" if original_filename.present?
  end
end
