class ApiPartner::WelcomesController < ApplicationController
  def web
    videos = JSON.parse(Net::HTTP.get(URI.parse("https://www.googleapis.com/youtube/v3/search?key=AIzaSyBLg6UmJ93T7Bt7JphKiSQUb8IaXurUBeI&channelId=UC-YzYZyjTNNWnWzXHecA8mg&part=id&order=date&maxResults=3"))).symbolize_keys
    highlight_normal = (Highlight.where("(expires_at is null or expires_at > '#{Time.now}') and status = 1").order("position DESC NULLS LAST, expires_at").limit(3).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::HighlightSerializer.new(u)).serializable_hash } rescue nil)
    # highlight_winner = (Highlight.where(status: "active", kind: "winner").order("position DESC NULLS LAST, created_at DESC").limit(4).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::HighlightSerializer.new(u)).serializable_hash } rescue nil)
    @welcomes = {
      highlights: highlights,
      partners: ::Partner.most_scored_month.limit(4).as_json(only: [:id, :name, :avatar]),
      events: (Highlight.where(status: "active").where(kind: "event").order("position DESC NULLS LAST, created_at DESC").limit(4).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::HighlightSerializer.new(u)).serializable_hash } rescue nil),
      videos: [
        { text: "Arquiteta Carol Ferreira", url: "https://www.youtube.com/embed/wd7kbxniqJo" },
        { text: "Boutique arquitetura", url: "https://www.youtube.com//embed/XXbk4RNLews" },
        { text: "Projeto D2N Arquitetura e Interiores", url: "https://www.youtube.com/embed/kU8EJ8-xJJ4" },
        { text: "Arquiteta Carmel", url: "https://www.youtube.com/embed/PsJn2RzSDSg" },
        { text: "Arquiteto Marcelo Colnaghi", url: "https://www.youtube.com/embed/ROPUQTheyzE" },
        { text: "Projeto Sesso & Dalanezi", url: "https://www.youtube.com/embed/WyW4jXlvyrw" },
      ],
    }
    render json: @welcomes, status: 200
  end

  def highlights
    @highlights = Highlight.where(status: "active")
    if !params[:kind].to_s.empty?
      @highlights = @highlights.where(kind: params[:kind].split(","))
    else
      @highlights = @highlights.where.not(kind: "campain").where("(expires_at is null or expires_at > '#{Time.now}')")
    end
    paginate json: @highlights.order("position DESC NULLS LAST, created_at DESC"), status: 200, each_serializer: ApiPartner::HighlightSerializer
  end

  def winners
    @highlights = params[:year] ? Highlight.winner.where("status = 1 and position between #{params[:year]}00 and #{params[:year]}99") : Highlight.winner
    paginate json: @highlights.order("position DESC NULLS LAST, created_at DESC"), status: 200, each_serializer: ApiPartner::HighlightSerializer
  end

  def campains
    @highlights = Highlight.campain.order("position DESC NULLS LAST, created_at DESC")
    paginate json: @highlights, status: 200, each_serializer: ApiPartner::CampainSerializer
  end

  def all
    render json: {
      banks: Bank.all,
      states: State.all,
      cities: City.all,
    }
  end
end
