class Api::V1::CommissionsController < Api::V1::BaseController

    def index
        commissions = if Commission.where("partner_id = ?", params[:partner_id])
            commissions = if params[:started_date] && params[:started_date] > Time.now() 
                end_date = params[:end_date] ? params[:end_date] : Time.now()
                commissions.where(:order_date => params[:started_date]..end_date)
            end
            paginate json: commissions ||= [] , status: 200
        else
            render json: { errors: "partner_id vazio" }, status: 422
        end
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
        params.require(:commission).permit(:partner_id, :order_id, :order_date, :order_price, 
        :client_name, :points, :percent, :percent_date, :sent_date, :created_at, :updated_at)
    end
      
end
