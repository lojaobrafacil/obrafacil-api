class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :aws

  def store_dir
    "images/#{model.imageable_type}/#{model.imageable_id}/#{model.id}"
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

  version :normal do
    process :resize_to_fit => [600, 600]
  end

  def filename
    "#{original_filename}_#{secure_token}.#{file.extension}" if original_filename.present?
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
