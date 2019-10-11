class Log::Coupon < ApplicationRecord
  belongs_to :coupon
  validates_uniqueness_of :external_order_id, scope: [:coupon_id], message: I18n.t("models.coupon.errors.already_used")
  scope :this_month, -> { where(created_at: Time.now.beginning_of_month..Time.now.end_of_month) }
end
