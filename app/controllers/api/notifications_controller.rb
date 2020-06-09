class Api::NotificationsController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_notification, only: [:update, :delete]

  def index
    @notifications = @current_user.notifications.order(:viewed, created_at: :desc)
    render json: @notifications, status: 200
  end

  def update
    if @notification.update(viewed: true)
      render json: @notification, status: 200
    else
      render json: { errors: @notification.errors.full_messages }, status: :success
    end
  end

  def view_all
    @current_user.notifications.update_all(viewed: true)
    render json: { success: true }, status: 204
  end

  def delete
    if @notification.delete
      render json: @notification, status: 200
    else
      render json: { errors: @notification.errors.full_messages }, status: :success
    end
  end

  def delete_all
    @current_user.notifications.delete_all
    render json: { success: true }, status: 204
  end

  private

  def set_notification
    @notification = Notification.find_by(id: params[:id])
    head 404 unless @notification
  end
end
