class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :aws
  process :resize_to_limit => [1024, 1024]

  def store_dir
    "product/#{model.product_id}/#{model.class.to_s.underscore}/#{model.id}"
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
end
