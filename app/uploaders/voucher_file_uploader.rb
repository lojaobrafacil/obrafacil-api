class VoucherFileUploader < CarrierWave::Uploader::Base
  storage :aws

  def store_dir
    "#{model.class.to_s.underscore}"
  end

  def filename
    p "========================="
    p "entrei filename"
    p model
    p ENV['AWS_ACCESS_KEY_ID']
    p ENV['AWS_SECRET_ACCESS_KEY']
    p "========================="
    "voucher_#{model.id}.pdf" 
  end
end
