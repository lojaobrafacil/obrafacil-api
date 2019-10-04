class Product < ApplicationRecord
  belongs_to :sub_category, optional: true
  belongs_to :unit
  belongs_to :supplier
  has_many :stocks, dependent: :destroy
  has_many :image_products, dependent: :destroy
  accepts_nested_attributes_for :stocks, allow_destroy: true

  validates_presence_of :name
  enum kind: [:own, :third_party, :not_marketed]
  enum status: [:inactive, :active, :deleted]

  after_create :generate_stocks

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def generate_stocks
    company = Company.all
    if !company.empty?
      company.each do |cp|
        cp.stocks.create(stock: 0, stock_min: 0, stock_max: 0, product: self)
      end
    end
  end
end
