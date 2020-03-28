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

  after_create :workers

  def primary_email; emails.find_by(primary: true) || emails.first; end
  def primary_phone; phones.find_by(primary: true) || phones.first; end

  def products
    Product.where("id in (select stocks.product_id from stocks where stocks.company_id = ?)", self.id)
  end

  def workers
    CompanyStocksWorker.perform_async(self.id)
  end
end
