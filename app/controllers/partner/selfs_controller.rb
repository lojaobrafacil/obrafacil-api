class Partner::SelfsController < Partner::BaseController
  def index
    @partner = current_partner_user.partner
    render json: @partner, status: 200, serializer: Partner::SelfSerializer
  end
end
