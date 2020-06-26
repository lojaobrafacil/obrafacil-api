class ApiPartner::PartnerProjectsController < ApiPartner::BaseController
  before_action :authenticate_api_partner_partner!, only: [:create, :update, :delete]
  before_action :find_project, only: [:update, :delete]

  def index
    @projects = PartnerProject.order(:project_date, :name, :id)
    render json: @projects, status: 200, each_serializer: ApiPartner::PartnerProjectsSerializer
  end

  def show
    @project = PartnerProject.where("metadata ilike ?", "%#{params[:id]}%").first
    return head 404 if !@project
    render json: @project, status: 200, serializer: ApiPartner::PartnerProjectSerializer
  end

  def create
    @project = current_api_partner_partner.projects.new(partner_project_params)

    if @project.save
      render json: @project, status: 201
    else
      render json: { errors: @partner.errors.full_messages }, status: 422
    end
  end

  def update
    @project.status = 1
    if @project.update(partner_project_params)
      render json: @project, status: 201
    else
      render json: { errors: @partner.errors.full_messages }, status: 422
    end
  end

  def delete
    if @project.delete
      render json: "#{@project.name} excluido com sucesso", status: 200
    else
      render json: { errors: @partner.errors.full_messages }, status: 422
    end
  end

  private

  def find_project
    @project = current_api_partner_partner.projects.find(params[:id])
    return head 404
  end

  def partner_project_params
    params.permit(:name, :project_date, :content, :environment,
                  :products, :city, :partner_id, images: [])
  end
end
