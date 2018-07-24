class Employee < ApplicationRecord
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  has_many :cashiers
  has_many :orders
  belongs_to :user, optional: true
  has_and_belongs_to_many :permissions
  accepts_nested_attributes_for :permissions, allow_destroy: true
  validates_presence_of :name
  include Contact

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end
end
