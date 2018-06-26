class ImageProduct < ApplicationRecord
  belongs_to :product

  mount_uploader :attachment, ImageUploader

end
