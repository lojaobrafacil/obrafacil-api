class Api::HighlightsController < Api::BaseController
  before_action :authenticate_admin_or_api!, except: [:index]
  before_action :set_highlight, only: [:show, :update, :destroy]

  def index
    @highlights = params[:kind] ? Highlight.where(kind: params[:kind]) : Highlight.where.not(kind: "campain")
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
    @highlight = Highlight.find_by(id: params[:id])
    head 404 if @highlight.nil?
  end

  def highlight_params
    params.permit(policy(Highlight).permitted_attributes)
  end
end
