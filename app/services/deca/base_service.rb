module Deca
  class BaseService
    attr_accessor :path, :id, :query, :body, :response, :url, :username, :password, :credentials

    def initialize(options)
      @url = ENV["DECA_ENDPOINT"] || "https://homologacao.decaclub.com.br/exclusive/api"
      @credentials = login unless !@credentials.nil? && @credentials["created"].to_time + @credentials["created"].to_i.hours > Time.now
    end

    def login
      req = Net::HTTP.post_form(URI.parse("#{@url}/login.json"), { username: ENV["DECA_USERNAME"], password: ENV["DECA_PASSWORD"] })
      JSON.parse(req.body)["data"]["attributes"]
    end

    def get
      url = URI("#{@url}/#{@path}")
      p url
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["Accept"] = "application/vnd.api+json"
      request["Content-Type"] = "application/vnd.api+json"
      request["Authorization"] = "Bearer #{@credentials["token"]}"

      response = http.request(request)
      @response = JSON.parse(response.read_body)
      @id = @response["data"].first["id"] rescue nil
      @body["id"] = @id if @id
      @response
    end

    def post
      if @body
        url = URI("#{@url}/#{@path}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["Accept"] = "application/vnd.api+json"
        request["Content-Type"] = "application/vnd.api+json"
        request["Authorization"] = "Bearer #{@credentials["token"]}"

        response = http.request(request, @body)
        @response = JSON.parse(response.read_body)
        @id = @response["data"].first["id"] rescue nil
        @response
      end
    end

    def put
      if @id && @body
        url = URI("#{@url}/#{@path}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Patch.new(url)
        request["Accept"] = "application/vnd.api+json"
        request["Content-Type"] = "application/vnd.api+json"
        request["Authorization"] = "Bearer #{@credentials["token"]}"

        response = http.request(request, @body)
        @response = JSON.parse(response.read_body)
      end
    end

    def delete
      if @id && @body
        url = URI("#{@url}/#{@path}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Delete.new(url)
        request["Accept"] = "application/vnd.api+json"
        request["Content-Type"] = "application/vnd.api+json"
        request["Authorization"] = "Bearer #{@credentials["token"]}"

        response = http.request(request)
        @response = JSON.parse(response.read_body)
      end
    end
  end
end
