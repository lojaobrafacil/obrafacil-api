class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one :client
  has_one :partner
  has_one :company
  has_one :employee
  enum kind: [:admin, :normal]
  validates_uniqueness_of :federal_registration
end
