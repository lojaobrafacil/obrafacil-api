class Company < ApplicationRecord
  belongs_to :billing_type, optional: true
  belongs_to :user, optional: true
  has_many :company_products
  has_many :price_percentages
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  enum tax_regime: [:simple, :normal, :presumed]
  validates_presence_of :name
  include Contact

  after_create :generate_price_percentages

  def products
    Product.where("id in (select cp.product_id from company_products as cp where cp.order_id = ?)", self.id)
  end

  def generate_price_percentages
    (1..5).each do |kind|
      self.price_percentages.create(kind: kind, margin: 0.0)
    end
  end
  
end
