class ApiPartner::WelcomesController < ApplicationController
  def web
    videos = JSON.parse(Net::HTTP.get(URI.parse("https://www.googleapis.com/youtube/v3/search?key=AIzaSyBLg6UmJ93T7Bt7JphKiSQUb8IaXurUBeI&channelId=UC-YzYZyjTNNWnWzXHecA8mg&part=id&order=date&maxResults=3"))).symbolize_keys
    @welcomes = {
      highlights: (Highlight.where.not(kind: ["event", "campain"]).order(position: :desc, updated_at: :desc).limit(4).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::HighlightSerializer.new(u)).serializable_hash } rescue nil),
      events: (Highlight.where(kind: "event").order(position: :desc, updated_at: :desc).limit(4).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::HighlightSerializer.new(u)).serializable_hash } rescue nil),
      campain_images: ["https://hubcoapp-images.s3-sa-east-1.amazonaws.com/campanhas/pmd-1.png",
                       "https://hubcoapp-images.s3-sa-east-1.amazonaws.com/campanhas/pmd-2.png",
                       "https://hubcoapp-images.s3-sa-east-1.amazonaws.com/campanhas/pmd-3.png",
                       "https://hubcoapp-images.s3-sa-east-1.amazonaws.com/campanhas/pmd-4.png"],
      videos: [
        { text: "", url: "https://www.youtube.com/embed/PsJn2RzSDSg" },
        { text: "", url: "https://www.youtube.com/embed/ROPUQTheyzE" },
        { text: "", url: "https://www.youtube.com/embed/WyW4jXlvyrw" },
      ],
    }
    render json: @welcomes, status: 200
  end

  def highlights
    @highlights = Highlight.where.not(kind: "campain").where(status: "active")
    if !params[:kind].to_s.empty?
      @highlights = @highlights.where(kind: params[:kind])
    else
      @highlights = @highlights.where("(expires_at is null or expires_at > '#{Time.now}') and (starts_in is null or starts_in < '#{Time.now}')")
    end
    paginate json: @highlights.order("position DESC NULLS LAST, created_at DESC"), status: 200, each_serializer: ApiPartner::HighlightSerializer
  end

  def winners
    @highlights = Highlight.winner.where("status = 1 and position between #{params[:year]}00 and #{params[:year]}99")
    paginate json: @highlights.order("position DESC NULLS LAST, created_at DESC"), status: 200, each_serializer: ApiPartner::HighlightSerializer
  end

  def campains
    @highlights = Highlight.campain.order("position DESC NULLS LAST, created_at DESC")
    paginate json: @highlights, status: 200, each_serializer: ApiPartner::CampainSerializer
  end
end
