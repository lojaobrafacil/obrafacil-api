class Employee < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :cashiers
  has_many :orders
  has_many :reports
  has_many :notifications, dependent: :destroy, as: :notified
  belongs_to :company, optional: true
  belongs_to :city, optional: true
  validates_presence_of :name, :federal_registration, :limit_margin
  validates :admin, :change_partners, :change_clients, :change_suppliers,
            :change_cashiers, :generate_nfe, :import_xml, :change_products, :order_client, :order_devolution,
            :order_cost, :order_done, :order_price_reduce, :order_inactive, :order_creation,
            :change_coupon, :change_campain, :change_highlight, :change_bank, :change_carrier, :change_employee,
            :change_scheduled_messages, :can_separate, :can_deliver, :can_check_order, inclusion: { in: [true, false], message: "%{value} deve ser TRUE ou FALSE" }
  validates_uniqueness_of :federal_registration, conditions: -> { where.not(active: false) }, case_sensitive: true
  before_save :default_values, if: Proc.new { |employee| employee.active? }
  # after_save :send_to_deca, if: Proc.new { |employee| employee.active? }
  before_validation :format_phone
  before_validation :set_default_password, on: :create, if: Proc.new { |employee| employee.active? }

  def default_values
    self.name = self.name.strip.titleize rescue nil
    self.federal_registration = self.federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
    self.state_registration = self.state_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
  end

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def send_to_deca
    DecaEmployeesWorker.perform_async(self.id)
  end

  def update_password(old_password, password, password_confirmation)
    msg ||= I18n.t("models.employee.errors.invalid_password") unless valid_password?(old_password)
    msg ||= I18n.t("models.employee.errors.password") if password.to_s.empty? || password.size < 8
    msg ||= I18n.t("models.employee.errors.password_not_match") unless password == password_confirmation
    msg.nil? ? update(password: password) : errors.add(:password, msg)
    msg.nil?
  end

  def reset_password(password, password_confirmation)
    msg ||= I18n.t("models.employee.errors.password") if password.to_s.empty? || password.size < 8
    msg ||= I18n.t("models.employee.errors.password_not_match") unless password == password_confirmation
    msg.nil? ? update(password: password) : errors.add(:password, msg)
    msg.nil?
  end

  def format_phone
    if !self.phone.to_s.empty?
      number = self.phone.gsub(/[^0-9+]\s*/, "").gsub(/\+55\s*/, "")
      msgs ||= "Formato inv??lido." if number.size > 15 || number.size < 9
      msgs ||= "Por favor, informar um n??mero de celular v??lido incluindo o d??gito 9." if number.size == 11 && number[2, 1] != "9"
      number = "+55#{number}" unless number.include? "+55"
      msgs.nil? ? self.phone = number : errors.add(:phone, msgs)
    end
    if !self.celphone.to_s.empty?
      number = self.celphone.gsub(/[^0-9+]\s*/, "").gsub(/\+55\s*/, "")
      msgs ||= "Formato inv??lido." if number.size > 15 || number.size < 8
      msgs ||= "Por favor, informar um n??mero de celular v??lido incluindo o d??gito 9." if number.size == 11 && number[2, 1] != "9"
      number = "+55#{number}" unless number.include? "+55"
      msgs.nil? ? self.celphone = number : errors.add(:celphone, msgs)
    end
  end

  def formatted_phone(with_country = false)
    begin
      num = phone
      num = num.split("+55")[1].insert(0, "(").insert(3, ") ").insert(9, "-")
      with_country ? num.insert(0, "#{phone[0..2]} ") : num
    rescue
      phone
    end
  end

  def formatted_celphone(with_country = false)
    begin
      num = celphone
      num = num.split("+55")[1].insert(0, "(").insert(3, ") ").insert(10, "-")
      with_country ? num.insert(0, "#{celphone[0..2]} ") : num
    rescue
      celphone
    end
  end

  private

  # to devise
  def set_default_password
    self.password = self.password_confirmation = (self.federal_registration.gsub(/[^0-9A-Za-z]/, "").upcase rescue self.federal_registration)
  end
end
