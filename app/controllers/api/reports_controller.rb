class Api::ReportsController < Api::BaseController
  def index
    model = params[:model].classify.constantize.all if params[:model]
    if model && model.size > 0
      if params[:fields]
        fields = params[:fields].split(",")
        pathname = "#{params[:model]}-#{DateTime.now.strftime("%d-%m-%Y")}.xlsx"
        ToXlsx.new(model, {titles: fields, attributes: fields, filename: pathname}).generate
        send_file Rails.root.join(pathname), filename: pathname
        # send_data model.where(select).csv_format(keys), filename: params[:model].pluralize + "-#{Date.today}.csv"
      end
    else
      render json: {:errors => ["model e fields devem ser enviados"]}, status: 422
    end
  end

  private

  def to_hash(item, arr_sep = ",", key_sep = ":")
    array = item.split(arr_sep)
    hash = {}

    array.each do |e|
      key_value = e.split(key_sep)
      hash[key_value[0]] = key_value[1]
    end

    return hash
  end
end
