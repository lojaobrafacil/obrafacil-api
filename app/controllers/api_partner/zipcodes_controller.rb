class ApiPartner::ZipcodesController < ApplicationController
  def by_code
    @zipcode = Zipcode.find_by_code(params[:code])
    return head 404 if @zipcode.nil?
    render json: @zipcode, status: 200
  end
end
