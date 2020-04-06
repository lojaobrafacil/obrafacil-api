class PartnerAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include RoundImage

  storage :aws
  process :resize_to_limit => [600, 600]

  version :rounded do
    process :round
  end

  version :rounded_small do
    process :resize_to_fit => [100, 100]
    process :round
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    "avatar.#{file.extension}" if original_filename.present?
  end

  protected

  def serializable_hash(options = {})
    e = {}
    super(options).each do |item|
      e.merge!(item[0] == "url" ? { item[0] => item[1] } : { item[0] => item[1]["url"] })
    end
    e
  end
end
