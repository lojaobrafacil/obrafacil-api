class Api::V1::ReportsController < ApplicationController
    def index
        model = params[:model].classify.constantize.all if params[:model]
        if model && model.size > 0
            if params[:model] && params[:fields] 
                fields = []
                params[:fields].split(",").map do |item|
                    fields << to_hash(item)
                end
                count = fields.size
                select = ""
                keys = []
                fields.each do |item|
                    count-=1
                    item.map do |key, value|
                        model.has_attribute?(key) || key == 'emails' || key == 'phones' || key == 'addresses' ? keys << key : break
                        case Partner.column_for_attribute(key).type
                        when :integer
                            select += key+" = " + value.to_s unless value.nil?
                        when :float
                            select += key+" = " + value.to_s unless value.nil?
                        when :string
                            select += "lower("+key+") like lower('%" + value.to_s + "%')" unless value.nil?
                        when :datetime
                            value = value.split(".")
                            select += key + "BETWEEN "+ Time.new(value[0].split("/")[2].to_i,value[0].split("/")[1].to_i, value[0].split("/")[0].to_i).to_s + " AND "+ Time.new(value[1].split("/")[2].to_i,value[1].split("/")[1].to_i, value[1].split("/")[0].to_i).to_s
                        else
                            select += "1 = 1"
                        end
                    end
                    select += " and " if count > 0
                end
                send_data model.where(select).to_csv(keys), filename: params[:model].pluralize+"-#{Date.today}.csv"
            end
        else
            render json: { :errors => ["model e fields devem ser enviados"] }, status: 200
        end
    end

    private
    
    def to_hash(item, arr_sep=',', key_sep=':')
      array = item.split(arr_sep)
      hash = {}

      array.each do |e|
        key_value = e.split(key_sep)
        hash[key_value[0]] = key_value[1]
      end

      return hash
    end
end
