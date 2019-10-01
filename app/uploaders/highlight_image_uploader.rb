class HighlightImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws

  version :small do
    process resize_and_pad: [500, 350, :transparent]
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
