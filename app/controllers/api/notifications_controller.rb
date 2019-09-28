class Api::NotificationsController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @partners = Partner.review
    @notifications = {
      total: @partners.count,
      unread: @partners.count,
      content: Partner.review.order(created_at: :desc).select(:id, :name, :created_at).map { |item| { title: "Novo parceiro #{item.name}", created_at: item.created_at, target_id: item.id, viewed: false } },
    }
    render json: @notifications, status: 200
  end
end
