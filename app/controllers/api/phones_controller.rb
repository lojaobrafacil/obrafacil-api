class Api::PhonesController < Api::BaseController
  def index
    @phones = Phone.all
    paginate json: @phones.order(:id), status: 200
  end

  def show
    @phone = Phone.find_by(id: params[:id])
    if @phone
      render json: @phone, status: 200
    else
      head 404
    end
  end

  def update
    @phone = Phone.find(params[:id])

    if @phone.update(phone_params)
      render json: @phone, status: 200
    else
      render json: {errors: @phone.errors}, status: 422
    end
  end

  def destroy
    @phone = Phone.find(params[:id])
    @phone.destroy
    head 204
  end

  private

  def phone_params
    params.permit(:phone, :contact, :@phone_type_id, :phonable_id, :phonable_type)
  end
end
