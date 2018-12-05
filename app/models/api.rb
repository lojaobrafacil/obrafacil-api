class Api < ApplicationRecord
  validates_presence_of :name, :federal_registration, :access_id, :access_key

  before_validation :generate_new_tokens!, on: :create

  def generate_new_tokens!
    self.access_id = SecureRandom.hex(10).upcase
    self.access_key = SecureRandom.hex(32).upcase
  end
end
