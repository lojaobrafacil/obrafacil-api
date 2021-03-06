class ApiPartner::WelcomesController < ApplicationController
  def web
    # videos = JSON.parse(Net::HTTP.get(URI.parse("https://www.googleapis.com/youtube/v3/search?key=AIzaSyBLg6UmJ93T7Bt7JphKiSQUb8IaXurUBeI&channelId=UC-YzYZyjTNNWnWzXHecA8mg&part=id&order=date&maxResults=3"))).symbolize_keys
    @welcomes = {
      highlights: (Highlight.where.not(kind: "campain").order("position DESC NULLS LAST, expires_at").limit(3).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::HighlightSerializer.new(u)).serializable_hash } rescue nil),
      partners: ::Partner.most_scored_month(Time.now.month - 1).limit(4).as_json(only: [:id, :name, :avatar]),
      events: (Highlight.where(status: "active").where(kind: "event").order("position DESC NULLS LAST, created_at DESC").limit(4).map { |u| ActiveModelSerializers::Adapter.configured_adapter.new(ApiPartner::HighlightSerializer.new(u)).serializable_hash } rescue nil),
      stores: [
        "Loja Pinheiros - Rua dos Pinheiros, 1278/1282. Pinheiros - São Paulo - SP - (011) 3031-6891.",
        "Loja Zona Norte - Av. Eng. Caetano Alvares, 4601/4409. Zona Norte - São Paulo - SP - (011) 2236-2799.",
        "Loja Zona Sul - Rua Dr. Alceu de Campos Rodrigues, 410. Zona Sul - São Paulo - SP - (011) 3045-1095.",
        "Loja Alphaville - Alameda Araguaia, 891-Alphaville industrial-  Barueri  SP - (011) 4191-1508.",
        "Loja Tatuapé (em breve) - Rua Eleonora Cintra, 87 - Jardim Anália Franco - Tatuapé   SP - (011) 2268-0126.",
      ],
      videos: [
        { text: "Depoimento Carol Cantelli", url: "https://www.youtube.com/embed/PXhweV7s11M" },
        { text: "Depoimento arquiteta Duda Senna", url: "https://www.youtube.com/embed/zK-O3Em5WNk" },
        { text: "Depoimento arquiteta Nina Fioretto", url: "https://www.youtube.com/embed/SVU7V_D5y5U" },
        { text: "Depoimento arquiteto Marcelo Colnaghi", url: "https://www.youtube.com/embed/-6611ARjDHY" },
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

  def warnings
    render json: [{
             url: "https://hubcoapp-images.s3-sa-east-1.amazonaws.com/pb/warning.jpeg",
             starts_at: Time.new(2020, 12, 24),
             end_at: Time.new(2021, 01, 03),
           }], status: 200
  end

  def all
    render json: {
      banks: Bank.all,
      states: State.all,
      cities: City.all,
    }
  end
end
