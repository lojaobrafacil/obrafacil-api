class Api::FiscalNotesController < Api::BaseController
  # before_action :authenticate_admin_or_api!

  def xml_to_xlsx
    file = FiscalNotesService::Convert.new(zip_params[:file])
    file.call

    if file.success?
      return send_file File.new("tmp/Outubro-2019-1.xlsx")
    else
      return render json: file.error_message, status: :unprocessable_entity
    end
  end

  def zip_params
    params.permit(:file)
  end
end
