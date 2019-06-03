class Region < ApplicationRecord
  has_many :states, dependent: :destroy

  validates_presence_of :name
end
