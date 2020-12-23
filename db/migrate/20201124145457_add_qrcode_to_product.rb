class AddQrcodeToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :qrcode, :string
    add_column :products, :path_qrcode, :string
  end
end
