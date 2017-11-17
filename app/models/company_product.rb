class CompanyProduct < ApplicationRecord
  belongs_to :company
  belongs_to :product
  validates_presence_of [:stock, :stock_max, :stock_min, :stock_date]
end
