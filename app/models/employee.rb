class Employee < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  has_many :cashiers
  has_many :orders
  validates_presence_of :name, :federal_registration, :limit_price_percentage
  validates :admin, :change_partners, :change_clients, :change_cashiers, :order_creation, 
            :generate_nfe, :import_xml, :change_products, :order_client, :order_devolution, 
            :order_cost, :order_done, :order_price_reduce, 
            :order_inactive, inclusion: { in: [true, false] }
  validates_uniqueness_of :federal_registration, conditions: -> { where.not(active: false) }, case_sensitive: true
  before_save :valid_federal_registration
  include Contact

  def valid_federal_registration
    self.federal_registration.gsub!(/[^0-9[a-z]+]\s*/, "")
  end

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end
end
