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
    render json: response, status: 200
  end

  def all
    @nts = @current_user.notifications.order(:viewed, created_at: :desc)
    response = {
      current_user: @current_user,
      states: State.all,
      address_types: AddressType.all,
      email_types: EmailType.all,
      phone_types: PhoneType.all,
      partner_groups: PartnerGroup.all,
      banks: Bank.all,
      notifications: {
        total: @nts.count,
        unread: @nts.where(viewed: false).count,
        content: @nts,
      },
      units: Unit.all,
      suppliers: Supplier.all,
      companies: Company.all,
    }
    render json: response, status: 200
  end
end
