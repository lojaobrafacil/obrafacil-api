class VoucherFileUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}"
  end

  def filename
    "voucher_#{model.id}.pdf"
  end
end
