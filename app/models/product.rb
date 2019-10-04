class Product < ApplicationRecord
  belongs_to :sub_category, optional: true
  belongs_to :unit
  belongs_to :supplier
  belongs_to :deleted_by, :class_name => "Employee", :foreign_key => "deleted_by_id", optional: true
  has_many :stocks, dependent: :destroy
  has_many :image_products, dependent: :destroy
  accepts_nested_attributes_for :stocks, allow_destroy: true
  after_create :generate_stocks

  validates_presence_of :name
  enum kind: [:own, :third_party, :not_marketed]
  enum status: [:inactive, :active, :deleted]
  enum suggested_price_role: [:bigger, :less, :equal]

  def destroy(employee_id)
    self.update(status: "deleted", deleted_at: Time.now, deleted_by_id: employee_id)
  end

  private

  def generate_stocks
    company = Company.all
    if !company.empty?
      company.each do |cp|
        cp.stocks.create(stock: 0, stock_min: 0, stock_max: 0, product: self)
      end
    end
  end
end
