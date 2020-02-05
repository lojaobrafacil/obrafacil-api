class Highlight < ApplicationRecord
  validates_presence_of :title
  enum status: [:inactive, :active]
  enum kind: [:normal, :campain, :winner, :event]
  mount_uploader :image, HighlightImageUploader
end
