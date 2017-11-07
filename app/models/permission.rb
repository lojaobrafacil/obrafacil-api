class Permission < ApplicationRecord
  has_and_belongs_to_many :employees
  validates_presence_of :name, uniqueness: { case_sensitive: true }
end
