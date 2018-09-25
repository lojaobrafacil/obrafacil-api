class Api::V2::PartnersController < Api::V2::Partner::ContactsController
  def show
    partner = current_api_v1_user ?  Partner.find_by(user_id: current_api_v1_user.id) : (render json: {errors: "Não Foi possivel encontrar o usuario"})
    partner = Partner.find(params[:id]) if current_api_v1_user&.admin?
    # authorize partner
    render json: partner, status: 200
  end
end
