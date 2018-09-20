class Partner < ApplicationRecord
  belongs_to :bank, optional: true
  belongs_to :user, optional: true
  has_many :log_premio_ideals, dependent: :destroy
  has_many :commissions, dependent: :destroy
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :commissions, allow_destroy: true
  enum kind: [:physical, :legal]
  enum origin: [:shop, :internet, :relationship, :nivaldo]
  enum cash_redemption: [:true, :false, :maybe]
  validates_presence_of :name, :kind
  validates_uniqueness_of :federal_registration, scope: :active 
  include Contact
  after_save :update_user
  
  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def update_user
    if self.active?
      if user = self.user
        user.update(federal_registration: self.federal_registration, email: self.federal_registration.to_s+'obrafacil.com') if user.federal_registration != self.federal_registration
      elsif user = User.find_by(federal_registration: self.federal_registration)
        user.update(partner_id: self.id)
      else
        self.build_user(email: self.federal_registration.to_s+"@obrafacil.com",
          federal_registration: self.federal_registration,
          password:"obrafacil2018",
          password_confirmation:"obrafacil2018" ).save
      end
    else
      user.destroy if !user.client&.active?
    end
  end
end
