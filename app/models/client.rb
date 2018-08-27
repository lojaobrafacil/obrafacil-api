class Client < ApplicationRecord
  belongs_to :billing_type, optional: true
  belongs_to :user, optional: true
  has_many :orders
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
  after_save :update_user

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def update_user
    if user = User.find_by(federal_registration: self.federal_registration)
      if self.active?
        user.update(client: self) unless user.client == self
        fdr_client = self.federal_registration
        user.update(email: fdr_client.to_s+'obrafacil.com', federal_registration: fdr_client) if user.federal_registration.to_s != fdr_client.to_s 
      else
        user.update!(client:nil)
        user.destroy if !user.partner&.active?
      end
    else
      self.build_user(email: self.federal_registration.to_s+"@obrafacil.com",
                      federal_registration: self.federal_registration,
                      password:"obrafacil2018",
                      password_confirmation:"obrafacil2018" ).save
    end
  end
end
