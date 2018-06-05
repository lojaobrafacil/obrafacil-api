class Api::V1::CommissionController < ApplicationController

    def index
        commissions = Commission.all
        paginate json: commissions.order(:id), status: 200
    end
    
    def create
        commission = Commission.new(commission_params)
    
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
        params.require(:commission).permit(:partner_id, :order_id, :order_date, :order_price, :client_name, :points, :percent, :percent_date, :sent_date, :created_at, :updated_at)
    end
      
end
