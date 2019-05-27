class Partner < ApplicationRecord
  belongs_to :bank, optional: true
  belongs_to :user, optional: true
  belongs_to :partner_group, optional: true
  belongs_to :deleted_by, :class_name => "Employee", :foreign_key => "deleted_by_id", optional: true
  belongs_to :created_by, :class_name => "Employee", :foreign_key => "created_by_id", optional: true
  has_one :coupon, dependent: :destroy
  has_many :log_premio_ideals, class_name: "Log::PremioIdeal", dependent: :destroy
  has_many :commissions, dependent: :destroy
  has_many :pi_vouchers
  has_many :phones, dependent: :destroy, as: :phonable
  has_many :addresses, dependent: :destroy, as: :addressable
  has_many :emails, dependent: :destroy, as: :emailable
  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :commissions, allow_destroy: true
  enum status: [:pre_active, :active, :inactive, :review, :deleted]
  enum kind: [:physical, :legal]
  enum origin: [:shop, :internet, :relationship, :nivaldo]
  enum cash_redemption: [:true, :false, :maybe]
  validates_presence_of :name, :kind, :status
  include Contact
  validates :federal_registration, presence: true, uniqueness: { allow_blank: true, case_sensitive: true }, if: Proc.new { |partner| partner.active? || partner.review? }
  validates :favored_federal_registration, presence: true, uniqueness: { allow_blank: true, case_sensitive: true }, if: Proc.new { |partner| partner.active? || partner.review? }
  after_save :update_user, :premio_ideal, if: Proc.new { |partner| partner.active? }
  after_save :create_coupon
  before_validation :validate_status
  before_validation :validate_status, on: :update
  before_validation :default_values, if: Proc.new { |partner| partner.active? || partner.review? }
  alias_attribute :vouchers, :pi_vouchers

  def email; emails.find_by(primary: true) || emails.first; end
  def phone; phones.find_by(primary: true) || phones.first; end

  def commissions_by_year(year); commissions.where("extract(year from order_date) = ?", year); end

  def default_values
    self.name = self.name.strip.titleize rescue nil
    self.federal_registration = self.federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
    self.favored_federal_registration = !self.favored_federal_registration&.empty? ? self.favored_federal_registration : self.federal_registration
    self.favored_federal_registration = self.favored_federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
    self.state_registration = self.state_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
  end

  def create_coupon
    if self.active?
      if self.coupon.nil?
        Coupon.create(name: "Parceiro #{self.name}", discount: 5.0, kind: 0, status: 1, starts_at: DateTime.now(), expired_at: DateTime.now + 1.year)
      else
        self.coupon.update(status: 1)
      end
    else
      self.coupon.update(status: 0) if !self.coupon.nil?
    end
  end

  def update_user
    if self.active?
      if user = self.user
        user.update(federal_registration: self.federal_registration.to_s, email: self.federal_registration.to_s + "@obrafacil.com") if user.federal_registration != self.federal_registration
      elsif user = User.find_by(federal_registration: self.federal_registration)
        user.update(partner: self)
      else
        self.build_user(email: self.federal_registration.to_s + "@obrafacil.com",
                        federal_registration: self.federal_registration,
                        password: "obrafacil2018",
                        password_confirmation: "obrafacil2018").save
      end
    else
      u = self.user
      if u
        u.update(partner: nil)
        u.destroy
      end
    end
  end

  def premio_ideal
    PremioIdealWorker.perform_async(id)
  end

  def destroy(employee_id)
    self.assign_attributes({ status: "deleted", deleted_at: Time.now, deleted_by_id: employee_id, user: nil })
    if self.save
      User.where(federal_registration: self.federal_registration).each do |user|
        user.destroy if user.client.nil? rescue nil
      end
    else
      false
    end
  end

  def self.commissions_by_year(year)
    Partner.select("partners.name as nome_parceiro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 01) as janeiro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 02) as fevereiro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 03) as marco, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 04) as abril, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 05) as maio, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 06) as junho, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 07) as julho, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 08) as agosto, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 09) as setembro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 10) as outubro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 11) as novembro, 
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 12) as dezembro")
  end

  private

  def validate_status
    if self.status_changed?
      case self.status_in_database
      when "review"
        errors.add(:status, I18n.t("activerecord.errors.partner.status.review_to_pre_active")) if self.status == "pre_active"
      when "pre_active"
        errors.add(:status, I18n.t("activerecord.errors.partner.status.pre_active_to_review")) if self.status == "review"
      when "active"
        errors.add(:status, I18n.t("activerecord.errors.partner.status.active_to_review")) if self.status == "review"
        errors.add(:status, I18n.t("activerecord.errors.partner.status.active_to_pre_active")) if self.status == "pre_active"
      end
    end
    errors.add(:deleted_at, I18n.t("activerecord.errors.partner.status.deleted_at", deleted_at: self.deleted_at.strftime("%d/%m/%Y %H:%M:%S"))) if !self.deleted_at_in_database.nil?
    errors.add(:deleted_by, I18n.t("errors.messages.blank")) if !self.deleted_at.nil? && self.deleted_by.nil?
    self.errors.messages.empty? ? true : (false; throw(:abort))
  end

  def validate_on_update
    errors.add(:created_by, I18n.t("errors.messages.blank")) if self.created_by.nil?
  end
end
