class Api::NotificationsController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_notification, only: [:update]

  def index
    @nts = @current_user.notifications.order(:viewed, created_at: :desc)
    @notifications = {
      total: @nts.count,
      unread: @nts.where(viewed: false).count,
      content: @nts,
    }
    render json: @notifications, status: 200
  end

  def update
    if @notification.update(viewed: true)
      render json: @notification, status: 200
    else
      render json: { errors: @notification.errors.full_messages }, status: :success
    end
  end

  private

  def set_notification
    @notification = Notification.find_by(id: params[:id])
    head 404 unless @notification
  end
end
