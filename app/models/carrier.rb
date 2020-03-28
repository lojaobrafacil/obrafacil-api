class Carrier < ApplicationRecord
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  # has_many :orders
  validates_presence_of :name
  enum kind: [:physical, :legal]

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def primary_email; emails.find_by(primary: true) || emails.first; end
  def primary_phone; phones.find_by(primary: true) || phones.first; end
end
