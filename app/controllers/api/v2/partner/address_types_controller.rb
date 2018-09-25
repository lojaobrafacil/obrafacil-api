class Api::V2::AddressTypesController < Api::V2::Partner::BaseController

  def index
    address_types = AddressType.all
    paginate json: address_types.order(:id), status: 200
  end

  def show
    address_type = AddressType.find(params[:id])
    render json: address_type, status: 200
  end
end



def show
  banner = Banner.find_by(date: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, approved: true)
  if banner.nil?
    banner = Banner.all.where(approved:true, date:nil)
    if banner.nil? 
      Banner.update_all(date:nil) 
      banner = Banner.all(approved:true, date:nil)
    end
    banner.update(date: Time.zone.now)
  end
  render json: banner
end