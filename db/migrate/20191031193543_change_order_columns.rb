class ChangeOrderColumns < ActiveRecord::Migration[5.2]
  def up
    # TemplateOrder
    remove_column :orders, :file, :string
    rename_column :orders, :billing_date, :billing_at
    rename_column :orders, :exclusion_date, :exclusion_at
    rename_column :orders, :discont, :discount
    rename_column :orders, :kind, :type
    add_column :orders, :discount_type, :integer, limit: 1
    add_column :orders, :status, :integer, limit: 1
    remove_reference :orders, :client, index: true, foreign_key: true
    add_column :orders, :buyer_type, :string
    add_column :orders, :buyer_id, :integer
    add_index :orders, [:buyer_type, :buyer_id]
    change_column :orders, :type, :string
    # order
    add_reference :orders, :partner, index: true, foreign_key: true
    change_column :orders, :discount, :float, precision: 5, scale: 2
    # devolution
    add_reference :orders, :order, index: true, foreign_key: true
    # loan / transfer
    add_column :orders, :billing_employee_id, :integer, index: true
  end

  def down
    add_column :orders, :file, :string
    rename_column :orders, :billing_at, :billing_date
    rename_column :orders, :exclusion_at, :exclusion_date
    rename_column :orders, :discount, :discont
    rename_column :orders, :type, :kind
    remove_column :orders, :discount_type, :integer
    remove_column :orders, :status, :integer
    remove_reference :orders, :partner, index: true, foreign_key: true
    remove_reference :orders, :order, index: true, foreign_key: true
    add_reference :orders, :client, index: true, foreign_key: true
    remove_index :orders, [:buyer_type, :buyer_id]
    remove_column :orders, :buyer_type, :string
    remove_column :orders, :buyer_id, :integer
    remove_column :orders, :billing_employee_id, :integer, index: true
  end
end
