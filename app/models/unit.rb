class Unit < ApplicationRecord
  validates_presence_of :name, :description, uniqueness: { case_sensitive: true }
  has_many :products

  def model
    
  end
end
