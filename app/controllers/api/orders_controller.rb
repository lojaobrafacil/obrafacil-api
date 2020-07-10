class Api::OrdersController < Api::BaseController
  before_action :authenticate_admin_or_api!

  def index
    @orders = policy_scope Order
    @orders = @orders.where(id: params[:ids].split(",")) if !params[:ids].to_s.empty?
    @orders = @orders.billing_at_range(params[:from].to_time.in_time_zone.beginning_of_day, params[:to].to_time.in_time_zone.end_of_day) if !params[:from]&.to_time.nil? && !params[:to]&.to_time.nil?
    @orders = @orders.where(status: params[:status]) if !params[:status].to_s.empty?
    @orders = @orders.where(company_id: params[:company_id]) if !params[:company_id].to_s.empty?

    respond_with do |format|
      format.json { paginate json: @orders.order(:id), status: 200, each_serializer: Api::OrdersSerializer }
      format.csv { send_data @orders.to_csv({ col_sep: "\t" }), filename: "pedidos-#{Time.now}.csv" }
      format.xlsx {
        ToXlsx.new(@orders, { titles: ["codigo", "No. Pedido", "Data da compra", "Nome do Cliente", "Valor do Pedido", "Valor pago com vale", "Enviado em", "Porcentagem", "Pontos/Produtos", "Pontos/Dinheiro", "Data envio", "Criado em", "Atualizado em"],
                             attributes: ["id", "order_id", "order_date", "client_name", "order_price", "return_price", "percent_date", "percent", "points", "percent_value", "sent_date", "created_at", "updated_at"] }).generate
        send_file Rails.root.join("ruby.xlsx"), filename: "pedidos-#{Time.now}.xlsx"
      }
    end
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order
      authorize @order
      render json: @order, status: 200, serializer: Api::OrderSerializer
    else
      head 404
    end
  end

  def create
    @order = Order.new(create_order_params)
    authorize @order
    if @order.save
      render json: @order, status: 201
    else
      render json: { errors: @order.errors.full_messages }, status: 422
    end
  end

  def update
    @order = Order.find(params[:id])
    authorize @order
    if @order.update(update_order_params)
      render json: @order, status: 200
    else
      render json: { errors: @order.errors.full_messages }, status: 422
    end
  end

  def destroy
    @order = Order.find(params[:id])
    authorize @order
    @order.destroy
    head 204
  end

  private

  def create_order_params
    # params.permit(policy(Order).permitted_attributes)
    params.permit(
      [:description, :discount, :freight, :billing_at,
       :file, :selected_margin, :employee_id,
       :buyer_id, :buyer_type, :cashier_id, :carrier_id, :company_id]
    )
  end

  def update_order_params
    params.permit(
      [:description, :discount, :freight, :billing_at,
       :file, :selected_margin, :employee_id,
       :buyer_id, :buyer_type, :cashier_id, :carrier_id, :company_id]
    )
  end
end
