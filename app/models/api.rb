class Api < ApplicationRecord
  validates_presence_of :name, :federal_registration
  validates_uniqueness_of [:access_id, :access_key], presence: true

  before_validation :generate_new_tokens!, on: :create
  enum kind: [:admin, :reader]

  def generate_new_tokens!
    self.access_id = SecureRandom.hex(10).upcase
    self.access_key = SecureRandom.hex(32).upcase
  end
end
