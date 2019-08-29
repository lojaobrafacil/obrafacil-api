class AddLimitPricingPercentageToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :limit_pricing_percentage, :integer, default: 1
  end
end
