class Zipcode < ApplicationRecord
  require "uri"
  require "net/http"
  belongs_to :city, optional: true
  validates_presence_of :code

  def self.find_by_code(code)
    begin
      @zipcode = Zipcode.find_by(code: code)
      if !@zipcode
        result = JSON.parse(Net::HTTP.get(URI.parse("https://viacep.com.br/ws/#{code}/json/"))).symbolize_keys
        result[:cep].slice!("-")
        @zipcode = Zipcode.create(
          code: result[:cep],
          place: result[:logradouro],
          neighborhood: result[:bairro],
          city_id: State.find_by(acronym: result[:uf]).cities.find_by(name: result[:localidade])&.id,
          ibge: result[:ibge],
          gia: result[:gia],
        )
      end
      @zipcode
    rescue
      nil
    end
  end
end
