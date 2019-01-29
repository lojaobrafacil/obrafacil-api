class Email < ApplicationRecord
  belongs_to :email_type
  belongs_to :emailable, polymorphic: true
  validates_presence_of :email
  validates_uniqueness_of :primary, scope: [:emailable_id, :emailable_type], message: I18n.t("activerecord.models.errors.email.attributes.primary"), if: Proc.new { |email| email.primary == true }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Invalid E-mail"
  before_validation :delete_write_spaces

  def delete_write_spaces
    self.email&.delete!(" ")
  end
end
