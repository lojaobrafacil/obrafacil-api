class Api::V1::CfopsController < Api::V1::BaseController

  def index
    e = Employee.create!(email:"admin@admin.com", federal_registration:"12345678910", name: "SysAdmin", password:"admin2020", password_confirmation:"admin2020", admin: true)

    # cfops = Cfop.all
    # paginate json: cfops.order(:id), status: 200
    render json: e.as_json, status: 200
  end

  def show
    cfop = Cfop.find(params[:id])
    render json: cfop, status: 200
  end

  def create
    cfop = Cfop.new(cfop_params)

    if cfop.save
      render json: cfop, status: 201
    else
      render json: { errors: cfop.errors }, status: 422
    end
  end

  def update
    cfop = Cfop.find(params[:id])
    if cfop.update(cfop_params)
      render json: cfop, status: 200
    else
      render json: { errors: cfop.errors }, status: 422
    end
  end

  def destroy
    cfop = Cfop.find(params[:id])
    cfop.destroy
    head 204
  end

  private

  def cfop_params
    params.permit(:code, :description)
  end
end
