class VoucherFileUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end
end
