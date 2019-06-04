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
  before_validation :set_default_to_devise, on: :create

  def primary_email; emails.find_by(primary: true) || emails.first; end
  def primary_phone; phones.find_by(primary: true) || phones.first; end

  def record_timestamps
    !self.new_record? && self.changed? && devise_attributes_changed? ? false : true
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

  def destroy
    self.assign_attributes({ status: "deleted" })
    self.save
  end

  private

  def default_values
    self.name = self.name.strip.titleize if self.name_changed?
    self.federal_registration = self.federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase if self.federal_registration_changed?
    self.state_registration = self.state_registration.gsub(/[^0-9A-Za-z]/, "").upcase if self.state_registration_changed?
  end

  # to devise
  def set_default_to_devise
    self.uid = ((Client.last&.id || 0) + 1).to_s + self.federal_registration rescue nil
    self.password = self.password_confirmation = SecureRandom.hex(4).upcase rescue nil
  end

  def devise_attributes_changed?
    arr = self.changes.symbolize_keys.keys
    [:reset_password_token, :reset_password_sent_at, :allow_password_change, :remember_created_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :tokens].map {
      |key|
      arr.include?(key)
    }.include?(true)
  end
end