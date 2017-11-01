class State < ApplicationRecord
  belongs_to :region
  has_many :cities, dependent: :destroy

  validates_presence_of :name, :acronym
end
