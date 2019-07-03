class Highlight < ApplicationRecord
  validates_presence_of :title_1, :content_1, :image_1
  enum status: [:inactive, :active]
  enum kind: [:normal, :campain, :winner, :event, :score]
  mount_uploader :image_1, HighlightImageUploader
  mount_uploader :image_2, HighlightImageUploader
  mount_uploader :image_3, HighlightImageUploader
end
