class Api::V2::CommissionsController < Api::V2::Admin::BaseController

    def index
        commissions = Commission.where("partner_id = ?", params[:partner_id]).order("order_date desc") if params[:partner_id]
        paginate json: commissions , status: 200
    end
    
    def create
        commission = Partner.find(commission_params[:partner_id]).commissions.new(commission_params.as_json(except:(:partner_id)))
    
        if commission.save
        render json: commission, status: 201
        else
        render json: { errors: commission.errors }, status: 422
        end
    end
    
    def update
        commission = Commission.find(params[:id])
    
        if commission.update(commission_params)
        render json: commission, status: 200
        else
        render json: { errors: commission.errors }, status: 422
        end
    end
    
    def destroy
        commission = Commission.find(params[:id])
        commission.destroy
        head 204
    end
    
    private
    
    def commission_params
        params.permit(:partner_id, :order_id, :order_date, :order_price, 
        :client_name, :return_price, :points, :percent, :percent_date, :sent_date)
    end
      
end
