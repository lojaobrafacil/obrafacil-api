class Email < ApplicationRecord
  belongs_to :email_type
  belongs_to :emailable, polymorphic: true
  validates_presence_of :email
end
