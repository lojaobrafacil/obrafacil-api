class Api::CampainsController < Api::BaseController
  before_action :authenticate_admin_or_api!, except: [:index]
  before_action :set_campain, only: [:show, :update, :destroy]

  def index
    @campains = Highlight.campain
    paginate json: @campains.order("position DESC NULLS LAST, created_at DESC"), status: 200, each_serializer: Api::CampainSerializer
  end

  def show
    render json: @campain, status: 200, serializer: Api::CampainSerializer
  end

  def create
    @campain = Highlight.new(campain_params)
    @campain.kind = "campain"
    if @campain.save
      render json: @campain, status: 201, serializer: Api::CampainSerializer
    else
      render json: { errors: @campain.errors }, status: 422
    end
  end

  def update
    @campain.remove_image_2! if campain_params[:image_2] == "remove"
    @campain.remove_image_3! if campain_params[:image_3] == "remove"
    if @campain.update(campain_params)
      render json: @campain, status: 200, serializer: Api::CampainSerializer
    else
      render json: { errors: @campain.errors }, status: 422
    end
  end

  def destroy
    @campain.destroy
    head 204
  end

  private

  def set_campain
    @campain = Highlight.find_by(id: params[:id], kind: "campain")
    head 404 if @campain.nil?
  end

  def campain_params
    params.permit(policy(Highlight).permitted_campain_attributes)
  end
end
