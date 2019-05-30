class Client < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  include Contact
  belongs_to :billing_type, optional: true
  has_many :orders, dependent: :destroy
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  enum status: [:inactive, :active, :deleted]
  enum kind: [:physical, :legal]
  enum tax_regime: [:simple, :normal, :presumed]
  validates_presence_of :name, :kind, :status
  before_save :default_values, if: Proc.new { |client| client.active? }

  def default_values
    self.name = self.name.strip.titleize rescue nil
    self.federal_registration = self.federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
    self.state_registration = self.state_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
  end

  def destroy(employee_id)
    self.assign_attributes({ status: "deleted", deleted_at: Time.now, deleted_by_id: employee_id }).save
  end
end
