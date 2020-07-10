class Api::DashboardController < Api::BaseController
  before_action :authenticate_api_employee!

  def index
    response = {}
    if @current_api_employee.admin || @current_api_employee.change_coupon
      response.merge!({
        coupons: Coupon.count,
        coupons_this_month: Coupon.this_month.count,
        coupons_used_this_month: ::Log::Coupon.this_month.count,
      })
    end
    if @current_api_employee.admin || @current_api_employee.change_partners
      response.merge!({
        partners: Partner.count,
        partners_active: Partner.active.count,
        partners_review: Partner.review.count,
        partners_this_month: Partner.this_month.count,
      })
    end
    if @current_api_employee.admin || @current_api_employee.can_separate || @current_api_employee.can_deliver || @current_api_employee.can_check_order
      response.merge!({
        deliveries: Delivery.count,
        deliveries_this_month: Delivery.this_month.count,
        deliveries_deliver: Delivery.deliver_this_month.count,
        deliveries_to_deliver: Delivery.to_delivery_today,
        deliveries_delivered: Delivery.delivered_this_month.count,
      })
    end
    render json: response, status: 200
  end

  def all
    response = {
      current_user: @current_user,
      states: State.all,
      address_types: AddressType.all,
      email_types: EmailType.all,
      phone_types: PhoneType.all,
      partner_groups: PartnerGroup.all,
      banks: Bank.all,
      notifications: @current_user.notifications.order(:viewed, created_at: :desc).limit(100),
      units: Unit.all,
      suppliers: Supplier.all,
      companies: Company.all,
    }
    render json: response, status: 200
  end
end
