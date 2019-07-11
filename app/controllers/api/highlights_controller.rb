class Api::HighlightsController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_highlight, only: [:show, :update, :destroy]

  def index
    query = []
    query << " status = '#{Highlight.statuses[params[:status]]}'" if !params[:status].to_s.empty?
    query << " kind = '#{Highlight.kinds[params[:kind]]}'" if !params[:kind].to_s.empty?
    @highlights = Highlight.where.not(kind: "campain").where(query.join(" and ").to_s).order(position: :desc, updated_at: :desc)
    paginate json: @highlights, status: 200
  end

  def show
    render json: @highlight, status: 200
  end

  def create
    @highlight = Highlight.new(highlight_params)

    if @highlight.save
      render json: @highlight, status: 201
    else
      render json: { errors: @highlight.errors }, status: 422
    end
  end

  def update
    if @highlight.update(highlight_params)
      render json: @highlight, status: 200
    else
      render json: { errors: @highlight.errors }, status: 422
    end
  end

  def destroy
    @highlight.destroy
    head 204
  end

  private

  def set_highlight
    @highlight = Highlight.where.not(kind: "campain").find_by(id: params[:id])
    head 404 if @highlight.nil?
  end

  def highlight_params
    params.permit(policy(Highlight).permitted_attributes)
  end
end
