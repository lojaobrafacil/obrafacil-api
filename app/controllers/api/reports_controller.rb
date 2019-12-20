class Api::ReportsController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    if params[:name]
      @reports = Report.where(name: params[:name].upcase).order(updated_at: :desc).limit(10)
      render json: @reports, status: 200
    else
      render json: { error: "Modelo é obrigatorio" }, status: 200
    end
  end

  def create
    model = params[:model].classify.constantize.all if params[:model]
    if model && model.size > 0
      if params[:fields]
        ReportUploadWorker.perform_async(type: "MODEL",
                                         user_id: current_api_employee.id,
                                         model: params[:model],
                                         titles: params[:titles] ? params[:titles].split(",") : params[:fields].split(","),
                                         fields: params[:fields].split(","),
                                         pathname: "#{params[:model]}-#{DateTime.now.strftime("%d%m%Y_%H%M%S")}.xlsx")
        render json: { success: "Estamos gerando o relatório, assim que estiver pronto, avisaremos." }, status: 200
      end
    else
      render json: { errors: ["model e fields devem ser enviados"] }, status: 422
    end
  end
end
