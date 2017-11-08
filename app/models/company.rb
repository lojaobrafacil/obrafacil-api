class Company < ApplicationRecord
  belongs_to :billing_type, optional: true
  belongs_to :user
  has_many :products
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  enum kind: [:physical, :legal]
  enum tax_regime: [:simple, :normal, :presumed]
  validates_presence_of :name
  include Contact

end
