class PartnerAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws
  process :resize_to_limit => [600, 600]

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    "avatar.#{file.extension}"
  end
end
