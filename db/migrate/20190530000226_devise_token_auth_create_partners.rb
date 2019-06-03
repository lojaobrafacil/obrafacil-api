class DeviseTokenAuthCreatePartners < ActiveRecord::Migration[5.2]
  def up
    change_table(:partners) do |t|
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :allow_password_change, :default => false
      t.datetime :remember_created_at
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip
      t.string :image
      t.string :email
      t.json :tokens
    end

    Partner.update_all("email= concat(partners.id, '_', partners.status, '_', partners.federal_registration, '@obrafacil.com.br')")
    Partner.update_all("provider= partners.email")
    execute("update partners
      set
        uid = users.uid,
        encrypted_password = users.encrypted_password,
        reset_password_token = users.reset_password_token,
        reset_password_sent_at = users.reset_password_sent_at,
        allow_password_change = true,
        remember_created_at = users.remember_created_at,
        sign_in_count = users.sign_in_count,
        current_sign_in_at = users.current_sign_in_at,
        last_sign_in_at = users.last_sign_in_at,
        current_sign_in_ip = users.current_sign_in_ip,
        last_sign_in_ip = users.last_sign_in_ip
      from users
      where partners.federal_registration = users.federal_registration")

    add_index :partners, :email, unique: true
    add_index :partners, [:uid, :provider], unique: true
    add_index :partners, :reset_password_token, unique: true
    add_index :partners, :confirmation_token, unique: true
    remove_column :partners, :user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't remove auths of partners"
  end
end
