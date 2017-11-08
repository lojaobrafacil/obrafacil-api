class Product < ApplicationRecord
  belongs_to :sub_category, optional: true
  belongs_to :unit
  belongs_to :company

  validates_presence_of :name
  enum kind: [:own, :third_party, :not_marketed]

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

end
