class Email < ApplicationRecord
  belongs_to :email_type
  belongs_to :emailable, polymorphic: true
  validates_presence_of :email
  validates_uniqueness_of :primary, scope: [:emailable_id, :emailable_type], message: I18n.t("models.errors.email.attributes.primary"), if: Proc.new { |email| Email.primary(emailable_id: email.emailable_id, emailable_type: email.emailable_type, id: email.id).size > 0 }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "invalido"
  before_validation :delete_write_spaces

  def partner
    self.emailable_type == "Partner" ? self.emailable : nil
  end

  def client
    self.emailable_type == "Client" ? self.emailable : nil
  end

  def delete_write_spaces
    self.email&.delete!(" ")
  end

  def self.primary(obj = {})
    e = obj.empty? ? where(primary: true) : where(primary: true, emailable_id: obj["emailable_id"], emailable_type: obj["emailable_type"])
    obj["id"] ? p.where.not(id: obj["id"]) : e
  end
end
