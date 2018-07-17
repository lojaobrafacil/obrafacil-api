class AddCompanyToPricePercentages < ActiveRecord::Migration[5.1]
  def change
    add_reference :price_percentages, :company, foreign_key: true
  end
end
