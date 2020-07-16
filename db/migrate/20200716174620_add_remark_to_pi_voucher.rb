class AddRemarkToPiVoucher < ActiveRecord::Migration[5.2]
  def change
    add_column :pi_vouchers, :remark, :text
  end
end
