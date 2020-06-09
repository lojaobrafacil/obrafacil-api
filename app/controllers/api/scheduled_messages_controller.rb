class Api::ScheduledMessagesController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @scheduled_messages = ScheduledMessage.all
    @scheduled_messages = @scheduled_messages.where(status: params[:status].split(",")) if params[:status] && !params[:status].empty?
    @scheduled_messages = @scheduled_messages.where("LOWER(name) LIKE LOWER('%#{params[:name]}%')") if params[:name] && !params[:name].empty?
    paginate json: @scheduled_messages, status: 200
  end

  def show
    @scheduled_message = ScheduledMessage.find_by(id: params[:id])
    if @scheduled_message
      render json: @scheduled_message, status: 200
    else
      head 404
    end
  end

  def create
    @scheduled_message = ScheduledMessage.new(scheduled_message_params)
    if @scheduled_message.save
      @scheduled_message.reload
      render json: @scheduled_message, status: 201
    else
      render json: { errors: @scheduled_message.errors.full_messages }, status: 422
    end
  end

  def run
    @scheduled_message = ScheduledMessage.find_by(id: params[:id])
    if @scheduled_message
      SendSmsWorker.perform_async(@scheduled_message.id)
      head 204
    else
      head 404
    end
  end

  def update
    @scheduled_message = ScheduledMessage.find(params[:id])
    if @scheduled_message.update(scheduled_message_params)
      render json: @scheduled_message, status: 200
    else
      render json: { errors: @scheduled_message.errors.full_messages }, status: 422
    end
  end

  def destroy
    @scheduled_message = ScheduledMessage.find(params[:id])
    @scheduled_message.destroy
    head 204
  end

  private

  def scheduled_message_params
    params.permit(:name, :text, :status, :receiver_type, :starts_at,
                  :finished_at, :frequency_type, :frequency, :repeat, :receiver_ids => [])
  end
end
