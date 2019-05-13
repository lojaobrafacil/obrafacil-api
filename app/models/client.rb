class Client < ApplicationRecord
  belongs_to :billing_type, optional: true
  belongs_to :user, optional: true
  has_many :orders, dependent: :destroy
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  enum kind: [:physical, :legal]
  enum tax_regime: [:simple, :normal, :presumed]
  validates_presence_of :name
  include Contact
  before_save :default_values, if: Proc.new { |client| client.active? }
  after_save :update_user

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def default_values
    self.name = self.name.strip.titleize rescue nil
    self.federal_registration = self.federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
    self.state_registration = self.state_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
  end

  def update_user
    if self.active?
      if user = self.user
        user.update(federal_registration: self.federal_registration.to_s, email: self.federal_registration.to_s + "@obrafacil.com") if user.federal_registration != self.federal_registration
      elsif user = User.find_by(federal_registration: self.federal_registration)
        user.update(client: self)
      else
        self.build_user(email: self.federal_registration.to_s + "@obrafacil.com",
                        federal_registration: self.federal_registration,
                        password: "obrafacil2018",
                        password_confirmation: "obrafacil2018").save
      end
    else
      u = self.user
      if u
        u.update(client: nil)
        u.destroy
      end
    end
  end
end
