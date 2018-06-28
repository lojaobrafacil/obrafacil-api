class ImageProduct < ApplicationRecord
  belongs_to :product
  validates_presence_of :attachment

  mount_uploader :attachment, ImageUploader

end
