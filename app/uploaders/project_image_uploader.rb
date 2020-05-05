class ProjectImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :aws
  process :resize_to_limit => [1024, 1024]

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
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
