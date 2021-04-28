class AddBirthdayToEmailAndAddPermissionToReceiveEmailsToPartner < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :birthday, :boolean, default: false
    add_column :partners, :allowed_receive_emails, :boolean, default: true
    add_column :partners, :invalidation_email_sent_at, :datetime
  end
end
