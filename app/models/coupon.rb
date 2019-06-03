class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :discount, :kind, :status, :starts_at, :expired_at
  enum kind: [:percent, :value]
  enum status: [:inactive, :active]
  before_validation :default_values, on: :create
  belongs_to :partner, optional: true
  has_many :logs, class_name: "Log::Coupon"

  attr_accessor :uses

  def uses
    self.logs.count rescue 0
  end

  def default_values
    self.code ||= generate_code
    self.shipping ||= false
    self.logged ||= false
    self.total_uses ||= 0
    self.client_uses ||= 0
    self.max_value ||= 0
  end

  def use(params)
    msg = []
    params.as_json.symbolize_keys! rescue nil
    params[:client_federal_registration] = params[:client_federal_registration].gsub(/[^0-9A-Za-z]/, "").upcase rescue nil
    if !params[:client_federal_registration].blank? && !params[:external_order_id].blank?
      if self.logs.where(external_order_id: params[:external_order_id]).empty?
        num_of_use = self.logs.count
        errors.add(:base, I18n.t("models.coupon.errors.already_used")) if num_of_use >= self.total_uses
        if self.client_uses != 0
          num_of_use_by_client = self.logs.where(client_federal_registration: params[:client_federal_registration]).count
          errors.add(:base, I18n.t("models.coupon.errors.already_used")) if num_of_use_by_client >= self.client_uses
        end
      else
        errors.add(:base, I18n.t("models.coupon.errors.already_used"))
      end
    else
      errors.add(:base, I18n.t("models.coupon.errors.params", param: params[:external_order_id].blank? ? "external_order_id" : "client_federal_registration"))
    end
    self.errors.messages.empty? ? (true; self.save; self.logs.create(params)) : false
  end

  private

  def generate_code
    code = SecureRandom.hex(3).upcase
    Coupon.find_by(code: code) ? generate_code : code
  end
end
