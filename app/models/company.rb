class Company < ApplicationRecord
  belongs_to :billing_type, optional: true
  has_many :stocks, dependent: :destroy
  has_many :orders
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  enum tax_regime: [:simple, :normal, :presumed]
  validates_presence_of :name
  include Contact

  after_create :workers

  def products
    Product.where("id in (select stocks.product_id from stocks where stocks.company_id = ?)", self.id)
  end

  def workers
    CompanyStocksWorker.perform_async(self.id)
  end
end
