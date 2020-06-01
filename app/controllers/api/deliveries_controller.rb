class Api::DeliveriesController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @deliveries = policy_scope Delivery
    paginate json: @deliveries, status: 200, each_serializer: Api::DeliverySerializer
  end
end
