class HighlightImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :aws
  process convert: "png"

  version :small do
    process resize_to_fill: [166, 166]
  end

  version :medium do
    process resize_to_fill: [193, 247]
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    "#{secure_token}.png" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def serializable_hash(options = {})
    e = {}
    super(options).each do |item|
      e.merge!(item[0] == "url" ? { item[0] => item[1] } : { item[0] => item[1]["url"] })
    end
    e
  end
end
