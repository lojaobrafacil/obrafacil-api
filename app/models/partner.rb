class Partner < ApplicationRecord
  belongs_to :bank, optional: true
  belongs_to :user, optional: true
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
    if user = User.find_by(federal_registration: self.federal_registration)
      if self.active?
        user.update(partner_id: self.id) unless user.partner.id == self.id
        fdr_partner = self.federal_registration
        user.update(email: fdr_partner.to_s+'obrafacil.com', federal_registration: fdr_partner) if user.federal_registration.to_s != fdr_partner.to_s 
      else
        user.update!(partner:nil)
        user.destroy if !user.client&.active?
      end
    else
      self.build_user(email: self.federal_registration.to_s+"@obrafacil.com",
                      federal_registration: self.federal_registration,
                      password:"obrafacil2018",
                      password_confirmation:"obrafacil2018" ).save
    end
  end

end
