class Api::Log::WorkersController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    case params[:name]
    when "sms"
      sms
    else
      head 404
    end
  end

  def sms
    @smss = ::Log::Worker.where name: "SmsPartnersWorker"
    authorize @smss

    render json: @smss.limit(300), each_serializer: Api::Log::SmsWorkerSerializer
  end

  def show
    @log = ::Log::Worker.find(params[:id])
    authorize @log
    render json: @log
  end
end
