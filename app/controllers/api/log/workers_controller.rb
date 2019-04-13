class Api::Log::WorkersController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def sms
    smss = ::Log::Worker.where name: "SmsPartnersWorker"
    authorize smss

    render json: smss.limit(300), each_serializer: Api::Log::SmsWorkerSerializer
  end

  def show
    sms = ::Log::PremioIdeal.find(params[:id])
    authorize sms
    render json: sms
  end
end
