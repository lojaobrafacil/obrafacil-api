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
        { text: "", url: "https://www.youtube.com/embed/WyW4jXlvyrw" },
        { text: "", url: "https://www.youtube.com/embed/kU8EJ8-xJJ4" },
        { text: "", url: "https://www.youtube.com/embed/sTdb4_NQAUE" },
      ],
    }
    render json: @welcomes, status: 200
  end

  def highlights
    @highlights = Highlight.where.not(kind: "campain").where(status: "active")
    @highlights = @highlights.where(kind: params[:kind]) if !params[:kind].to_s.empty?
    paginate json: @highlights.order(:position, created_at: :desc), status: 200, each_serializer: ApiPartner::HighlightSerializer
  end

  def campains
    @highlights = Highlight.campain.order(position: :desc, created_at: :desc)
    paginate json: @highlights, status: 200, each_serializer: ApiPartner::CampainSerializer
  end
end
