class Api::FiscalNotesController < Api::BaseController
  # before_action :authenticate_admin_or_api!

  def xml_to_xlsx
    file = FiscalNotesService::Convert.new(zip_params[:file])
    file.call
    return render json: file.error_message, status: :unprocessable_entity if file.error_message
    send_file file.result
  end

  def zip_params
    params.permit(:file)
  end
end
