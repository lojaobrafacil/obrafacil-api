class Api::PartnerProjectsController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_partner_project, only: [:show, :update, :destroy, :images, :image_position]

  def index
    @partner_projects = policy_scope PartnerProject
    paginate json: @partner_projects.order(:status), status: 200, each_serializer: Api::PartnerProjectSerializer
  end

  def show
    return render json: @partner_project, status: 200, serializer: Api::PartnerProjectSerializer
  end

  def create
    @partner_project = PartnerProject.new(partner_project_params)
    if @partner_project.save
      render json: @partner_project, status: 201
    else
      render json: { errors: @partner_project.errors.full_messages }, status: 422
    end
  end

  def update
    if @partner_project.update(partner_project_params)
      render json: @partner_project, status: 200
    else
      render json: { errors: @partner_project.errors.full_messages }, status: 422
    end
  end

  def destroy
    authorize @partner_project
    if @partner_project.destroy(@current_user.id)
      render json: { success: "Sucesso" }, status: 200
    else
      render json: { errors: @partner_project.errors.full_messages }, status: 422
    end
  end

  def images
    authorize @partner_project
    render json: @partner_project.images, status: 200
  end

  def image_position
    authorize @partner_project
    if @partner_project.update(images_params)
      render json: @partner_project, status: 200
    else
      render json: { errors: @partner_project.errors.full_messages }, status: 422
    end
  end

  private

  def set_partner_project
    @partner_project = PartnerProject.find_by(id: params[:id])
    head 404 unless @partner_project
  end

  def partner_project_params
    params.permit(policy(PartnerProject).permitted_attributes)
  end

  def images_params
    params.permit({ images: [:id, :position] })
  end
end
