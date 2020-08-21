class Highlight < ApplicationRecord
  has_many :images, dependent: :destroy, as: :imageable
  accepts_nested_attributes_for :images, allow_destroy: true
  validates_presence_of :title
  enum status: [:inactive, :active]
  enum kind: [:normal, :campain, :winner, :event]
  mount_uploader :image, HighlightImageUploader
  mount_uploader :secondaryImage, HighlightImageUploader
  before_save :validate_metadata

  def validate_metadata
    self.metadata = "<p><br></p>" if self.metadata.to_s.empty?
  end
end
