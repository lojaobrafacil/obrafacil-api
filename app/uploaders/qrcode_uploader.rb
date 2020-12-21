class QrcodeUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def filename
    "qrcode_#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
