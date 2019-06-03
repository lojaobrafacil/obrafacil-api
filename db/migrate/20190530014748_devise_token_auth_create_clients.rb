class DeviseTokenAuthCreateClients < ActiveRecord::Migration[5.2]
  def change
    change_table(:clients) do |t|
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
      t.integer :status
      t.datetime :birthday
    end

    Client.update_all("email= concat(clients.id, '_', clients.status, '_', clients.federal_registration, '@obrafacil.com.br')")
    Client.update_all("provider= clients.email")
    execute("update clients
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
      where clients.federal_registration = users.federal_registration")

    add_index :clients, :email, unique: true
    add_index :clients, [:uid, :provider], unique: true
    add_index :clients, :reset_password_token, unique: true
    add_index :clients, :confirmation_token, unique: true
    remove_column :clients, :user_id
    remove_column :clients, :active
    remove_column :clients, :birth_date
  end
end
