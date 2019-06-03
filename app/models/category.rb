class Category < ApplicationRecord
  has_many :sub_categories, dependent: :destroy
  validates_presence_of :name
end
