class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.string :email
      t.string :contact
      t.integer :emailable_id
      t.string :emailable_type
      t.references :email_type, foreign_key: true

      t.timestamps
    end
  end
end
