class Partner < ApplicationRecord
  default_scope { where.not(status: "deleted") }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User
  belongs_to :bank, optional: true
  belongs_to :partner_group, optional: true
  belongs_to :deleted_by, :class_name => "Employee", :foreign_key => "deleted_by_id", optional: true
  belongs_to :created_by, :class_name => "Employee", :foreign_key => "created_by_id", optional: true
  has_many :coupons, dependent: :destroy
  has_many :log_premio_ideals, class_name: "Log::PremioIdeal", dependent: :destroy
  has_many :orders
  has_many :commissions, dependent: :destroy
  has_many :pi_vouchers
  has_many :projects, class_name: :PartnerProject, dependent: :destroy
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
  # validates_length_of :aboutme, :maximum => 255, allow_blank: true
  validates :federal_registration,
            presence: true,
            uniqueness: { allow_blank: true, case_sensitive: true },
            if: Proc.new { |partner| (partner.active? || partner.review?) && ["active", "review"].map { |value| Partner.where.not(id: partner.id).where(federal_registration: partner.federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase).pluck(:status).include?(value) }.include?(true) }
  validates :favored_federal_registration,
            presence: true,
            uniqueness: { allow_blank: true, case_sensitive: true },
            if: Proc.new { |partner| (partner.active? || partner.review?) && ["active", "review"].map { |value| Partner.where.not(id: partner.id).where(favored_federal_registration: partner.favored_federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase).pluck(:status).include?(value) }.include?(true) }
  after_save :premio_ideal, if: Proc.new { |partner| partner.active? }
  before_save :send_invalidation_email, if: Proc.new { |partner| partner.inactive? && !partner.invalidation_email_sent_at? }
  after_create :create_notification
  after_save :update_notification
  after_save :create_coupon
  before_validation :validate_status
  before_validation :set_default_to_devise, if: Proc.new { |partner| partner.uid.to_s.empty? }
  before_validation :validate_on_update, on: :update
  before_validation :default_values
  alias_attribute :vouchers, :pi_vouchers
  mount_uploader :avatar, PartnerAvatarUploader
  mount_uploader :project_image, PartnerImageUploader
  scope :this_month, -> { where(created_at: Time.now.beginning_of_month..Time.now.end_of_month) }

  def coupon
    coupons.order(:created_at).first
  end

  def self.most_scored_month(month = false)
    start = Commission.where("created_at > ?", Time.now.beginning_of_month).count > 0 ? Time.now : Time.now.change(month: Time.now.month - 1)
    Partner.joins(:commissions)
      .select("partners.*, coalesce(sum(commissions.order_price), 0) as soma")
      .where("can_published = true and extract(year from commissions.order_date) = ? and (extract(month from commissions.order_date) = ? or extract(month from commissions.order_date) = ?) and avatar is not null", start.year, month ? month : start.month, month ? month : Time.now.month)
      .group("partners.id")
      .order("soma desc")
  end

  def primary_email; emails.find_by(primary: true) || emails.first; end
  def birthday_email; emails.find_by(birthday: true) || primary_email; end
  def primary_phone; phones.find_by(primary: true) || phones.first; end

  def commissions_by_year(year); commissions.where("extract(year from order_date) = ?", year); end

  def create_coupon
    if self.active?
      if self.coupons.empty?
        self.coupons.create(name: "Parceiro #{self.name}", discount: 5.0, kind: 0, status: 0, starts_at: DateTime.now(), expired_at: DateTime.now + 1.year)
      else
        self.coupon
      end
      if self.confirmation_sent_at.nil?
        pass = SecureRandom.alphanumeric(10)
        PartnerMailer.first_access(self, pass).deliver_now if !self.primary_email.nil? && !self.coupon.nil? && self.update(confirmation_sent_at: Time.now, password: pass)
      end
    else
      self.coupon.update(status: 0) if !self.coupon.nil?
    end
  end

  def premio_ideal
    PremioIdealWorker.perform_async(id) if !devise_attributes_changed?
  end

  def destroy(employee_id)
    self.update(status: "deleted", deleted_at: Time.now, deleted_by_id: employee_id)
  end

  def self.commissions_by_year(year)
    Partner.select("partners.id as codigo_parceiro,  partners.name as nome_parceiro,
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
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year} and extract(month from c.order_date) = 12) as dezembro,
      (select coalesce(sum(c.order_price), 0) from commissions as c where c.partner_id = partners.id and extract(year from c.order_date) = #{year}) as soma").order("soma desc")
  end

  def active_for_authentication?
    super && self.active?
  end

  def inactive_message
    self.active? ? super : :inactive
  end

  def provider
    "federal_registration"
  end

  def update_password(current_password, password, password_confirmation)
    msg ||= I18n.t("models.user.errors.invalid_password") unless self.valid_password?(current_password)
    msg ||= I18n.t("models.user.errors.password_not_match") unless password == password_confirmation
    msg.nil? ? update(password: password, password_confirmation: password_confirmation) : errors.add(:password, msg)
    msg.nil?
  end

  def forgot_password
    if self.primary_email
      pass = SecureRandom.alphanumeric(10)
      self.update(password: pass)
      PartnerMailer.forgot_password_instruction(self, pass).deliver_now
    end
  end

  def record_timestamps
    self.new_record? || (self.changed? && !devise_attributes_changed?)
  end

  private

  def create_notification
    if self.status == "review"
      Employee.where("admin = true or change_partners = true").pluck(:id).each do |employee_id|
        @nt = Notification.find_or_initialize_by(notified_id: employee_id, notified_type: "Employee", target: self)
        @nt.update(title: "Novo parceiro #{self.name}", viewed: false)
        @nt.save
        Pusher.trigger("employee-#{employee_id}", "new-partner", { message: "Parceiro #{self.name} se cadastrou.", partner: self.as_json })
      end
    end
  end

  def send_invalidation_email
    PartnerMailer.need_more_informations(self).deliver_now
    self.invalidation_email_sent_at = Time.now
  end

  def update_notification
    Notification.where(notified_type: "Employee", target: self).update_all(viewed: true)
    Pusher.trigger("employees", "refresh-notifications", { partner: self })
  end

  def default_values
    if self.active? || self.review?
      self.name = self.name.to_s.strip.mb_chars.titleize.to_s if self.name_changed? || self.new_record? rescue nil
      self.federal_registration = self.federal_registration.to_s.gsub(/[^0-9A-Za-z]/, "").upcase if self.federal_registration_changed? || self.new_record? rescue nil
      self.favored_federal_registration = self.favored_federal_registration.to_s.empty? ? self.federal_registration : self.favored_federal_registration
      self.favored_federal_registration = self.favored_federal_registration.to_s.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
      self.state_registration = self.state_registration.to_s.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
      self.invalidation_email_sent_at = nil
    end
    self.searcher = "#{self.name} #{self.federal_registration === self.favored_federal_registration ? "#{self.federal_registration} #{self.favored_federal_registration}" : self.federal_registration} #{self.state_registration} #{self.status}"
    self.emails.each { |email| self.searcher += " #{email.email}" } if self.emails
    self.phones.each { |phone| self.searcher += " #{phone.phone}" } if self.phones
  end

  def validate_status
    if self.status_changed?
      case self.status_in_database
      when "review"
        errors.add(:status, I18n.t("activerecord.errors.messages.partner.status.review_to_pre_active")) if self.status == "pre_active"
      when "pre_active"
        errors.add(:status, I18n.t("activerecord.errors.messages.partner.status.pre_active_to_review")) if self.status == "review"
      when "active"
        errors.add(:status, I18n.t("activerecord.errors.messages.partner.status.active_to_review")) if self.status == "review"
        errors.add(:status, I18n.t("activerecord.errors.messages.partner.status.active_to_pre_active")) if self.status == "pre_active"
      end
    end
    errors.add(:deleted_at, I18n.t("activerecord.errors.messages.partner.status.deleted_at", deleted_at: self.deleted_at.strftime("%d/%m/%Y %H:%M:%S"))) if !self.deleted_at_in_database.nil?
    errors.add(:deleted_by, I18n.t("errors.messages.blank")) if !self.deleted_at.nil? && self.deleted_by_id.nil?
    self.errors.messages.empty? ? true : (false; throw(:abort))
  end

  def validate_on_update
    errors.add(:created_by, I18n.t("errors.messages.blank")) if self.created_by.nil?
  end

  # to devise
  def set_default_to_devise
    self.uid = SecureRandom.uuid
    self.password = self.password_confirmation = SecureRandom.alphanumeric(10)
  end

  def devise_attributes_changed?
    arr = self.changes.symbolize_keys.keys
    [:reset_password_token, :reset_password_sent_at, :allow_password_change, :remember_created_at, :confirmation_token, :confirmed_at, :unconfirmed_email, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :tokens].map {
      |key|
      arr.include?(key)
    }.include?(true)
  end
end
