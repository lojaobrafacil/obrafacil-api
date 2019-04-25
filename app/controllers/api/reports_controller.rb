class Api::ReportsController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @reports = Report.order(updated_at: :desc).limit(10)
    render json: @reports, status: 200
  end

  def create
    model = params[:model].classify.constantize.all if params[:model]
    if model && model.size > 0
      if params[:fields]
        ReportUploadWorker.perform_async(type: "MODEL",
                                         user_id: current_api_employee.id,
                                         model: params[:model],
                                         titles: params[:fields].split(","),
                                         fields: params[:fields].split(","),
                                         pathname: "#{params[:model]}-#{DateTime.now.strftime("%d%m%Y_%H%M%S")}.xlsx")
        render json: { :success => "Estamos gerando o relatório, assim que estiver pronto, avisaremos." }, status: 200
      end
    else
      render json: { :errors => ["model e fields devem ser enviados"] }, status: 422
    end
  end

  private

  def to_hash(item, arr_sep = ",", key_sep = ":")
    array = item.split(arr_sep)
    hash = {}

    array.each do |e|
      key_value = e.split(key_sep)
      hash[key_value[0]] = key_value[1]
    end

    return hash
  end
end
