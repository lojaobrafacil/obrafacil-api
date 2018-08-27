class Api::V2::Admin::CommissionsController < Api::V2::Admin::BaseController

  def index
    commissions = policy_scope [:admin, Commission]
    commissions.where("partner_id = ?", params[:partner_id]).order("order_date desc") if params[:partner_id]
    paginate json: commissions , status: 200
  end
  
  def create
    commission = Partner.find(commission_params[:partner_id]).commissions.new(commission_params.as_json(except:(:partner_id)))
    authorize [:admin, commission]
    if commission.save
    render json: commission, status: 201
    else
    render json: { errors: commission.errors }, status: 422
    end
  end
  
  def update
    commission = Commission.find(params[:id])
    authorize [:admin, commission]
    if commission.update(commission_params)
    render json: commission, status: 200
    else
    render json: { errors: commission.errors }, status: 422
    end
  end
  
  def destroy
    commission = Commission.find(params[:id])
    authorize [:admin, commission]
    commission.destroy
    head 204
  end
  
  private
  
  def commission_params
    params.permit(policy([:admin, Commission]).permitted_attributes)
  end
      
end
