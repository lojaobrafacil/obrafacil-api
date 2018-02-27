class Product < ApplicationRecord
  belongs_to :sub_category, optional: true
  belongs_to :unit
  belongs_to :provider, optional: true
  has_many :company_products
  accepts_nested_attributes_for :company_products, allow_destroy: true

  validates_presence_of :name
  enum kind: [:own, :third_party, :not_marketed]

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end
end
