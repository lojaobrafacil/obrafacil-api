class Api::V2::Admin::CommissionsController < Api::BaseController

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
  
  def destroy_all
    commissions = policy_scope [:admin, Commission]
    if params[:partner_id]&.is_a?(Integer) && c = commissions.where("partner_id = ?", params[:partner_id])
      c.destroy_all if c.size > 0
      render json: { success: "Deletado todos as comissoes do parceiro " + params[:partner_id] }, status: 204
    else
      render json: { errors: "partner_id necessario" }, status: 422
    end
  end
  
  private
  
  def commission_params
    params.permit(policy([:admin, Commission]).permitted_attributes)
  end
      
end
