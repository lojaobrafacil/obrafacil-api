class Api::ProjectImagesController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_project_image, only: [:show, :update, :destroy, :images]

  def index
    @project_images = policy_scope ProjectImage
    paginate json: @project_images.order(:position), status: 200
  end

  def show
    return render json: @project_image, status: 200
  end

  def create
    @project_image = ProjectImage.new(project_image_params)
    if @project_image.save
      render json: @project_image, status: 201
    else
      render json: { errors: @project_image.errors.full_messages }, status: 422
    end
  end

  def update
    if @project_image.update(project_image_params)
      render json: @project_image, status: 200
    else
      render json: { errors: @project_image.errors.full_messages }, status: 422
    end
  end

  def destroy
    authorize @project_image
    if @project_image.destroy
      render json: { success: "Sucesso" }, status: 200
    else
      render json: { errors: @project_image.errors.full_messages }, status: 422
    end
  end

  private

  def set_project_image
    @project_image = ProjectImage.find_by(id: params[:id])
    head 404 unless @project_image
  end

  def project_image_params
    params.permit(:partner_project_id, :attachment, :remote_attachment_url)
  end
end
