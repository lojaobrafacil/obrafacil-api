class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  validates_presence_of :attachment

  mount_uploader :attachment, ImageUploader
end
