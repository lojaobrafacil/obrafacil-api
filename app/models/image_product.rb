class ImageProduct < ApplicationRecord
  belongs_to :product

  mount_uploaders :attachment, ImageUploader

end
