class Api::PartnerGroupsController < Api::BaseController
  before_action :set_partner_group, only: [:show, :update, :destroy]
  before_action :authenticate_admin_or_api!

  def index
    @partner_groups = PartnerGroup.all
    paginate json: @partner_groups
  end

  def show
    render json: @partner_group
  end

  def create
    @partner_group = PartnerGroup.new(partner_group_params)

    if @partner_group.save
      render json: @partner_group, status: :created
    else
      render json: { errors: @partner_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @partner_group.update(partner_group_params)
      render json: @partner_group
    else
      render json: { errors: @partner_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @partner_group.destroy
  end

  private

  def set_partner_group
    @partner_group = PartnerGroup.find(params[:id])
  end

  def partner_group_params
    params.permit(:name)
  end
end
