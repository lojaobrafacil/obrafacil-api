module Deca
  class BaseService
    attr_accessor :path, :id, :deca_id, :query, :body, :response, :host, :username, :password, :credentials

    def initialize(options)
      @host = ENV["DECA_ENDPOINT"] || "https://homologacao.decaclub.com.br/exclusive/api"
      @credentials = login unless !@credentials.empty? && @credentials["created"].to_time + @credentials["token_lifetime"].to_i.hours > Time.now
    end

    def login
      req = Net::HTTP.post_form(URI.parse("#{@host}/login.json"), { username: ENV["DECA_USERNAME"], password: ENV["DECA_PASSWORD"] })
      JSON.parse(req.body)["data"]["attributes"]
    end

    def get
      url = URI(endpoint)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      request["Accept"] = "application/vnd.api+json"
      request["Content-Type"] = "application/vnd.api+json"
      request["Authorization"] = "Bearer #{@credentials["token"]}"

      response = http.request(request)
      @response = JSON.parse(response.read_body)
      @deca_id = @response["data"].first["id"] rescue nil
      if @deca_id
        @body[:data][:id] = @deca_id
        @path = "vendedores/#{@deca_id}"
        @body[:deca][:attributes].delete(:cpf_cnpj) rescue nil
      end
      @response
    end

    def post
      if @body
        url = URI(endpoint)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["Accept"] = "application/vnd.api+json"
        request["Content-Type"] = "application/vnd.api+json"
        request["Authorization"] = "Bearer #{@credentials["token"]}"

        response = http.request(request, @body.to_json)
        @response = JSON.parse(response.read_body)
        @deca_id = @response["data"].first["id"] rescue nil
        @response
      end
    end

    def put
      if @id && @body
        url = URI(endpoint)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Patch.new(url)
        request["Accept"] = "application/vnd.api+json"
        request["Content-Type"] = "application/vnd.api+json"
        request["Authorization"] = "Bearer #{@credentials["token"]}"

        response = http.request(request, @body.to_json)
        @response = JSON.parse(response.read_body)
      end
    end

    def delete
      if @id && @body
        url = URI(endpoint)
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

    def endpoint
      "#{@host}/#{@path}"
    end
  end
end
