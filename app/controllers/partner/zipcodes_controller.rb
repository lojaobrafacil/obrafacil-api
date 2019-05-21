class Partner::ZipcodesController < ApplicationController
  def by_code
    @zipcode = Zipcode.find_by_code(params[:code])
    render json: @zipcode, status: 200
  end
end
