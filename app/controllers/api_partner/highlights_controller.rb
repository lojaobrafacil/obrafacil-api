class ApiPartner::HighlightsController < ApiPartner::BaseController
  def index
    @highlights = Highlight.where(status: "active")
    if !params[:kind].to_s.empty?
      @highlights = @highlights.where(kind: params[:kind].split(","))
    else
      @highlights = @highlights.where.not(kind: "campain").where("(expires_at is null or expires_at > '#{Time.now}')")
    end
    paginate json: @highlights.order("position DESC NULLS LAST, created_at DESC"), status: 200, each_serializer: ApiPartner::HighlightSerializer
  end

  def show
    @highlight = Highlight.find_by(id: params[:id])
    render json: @highlight, status: 200
  end
end
