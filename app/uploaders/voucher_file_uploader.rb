class VoucherFileUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}"
  end
end
