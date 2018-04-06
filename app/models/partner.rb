class Partner < ApplicationRecord
  belongs_to :bank, optional: true
  belongs_to :user, optional: true
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  enum kind: [:physical, :legal]
  enum origin: [:shop, :internet, :relationship]
  validates_presence_of :name, :kind
  # validates_uniqueness_of :federal_tax_number, scope: :active 
  include Contact

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end
end
