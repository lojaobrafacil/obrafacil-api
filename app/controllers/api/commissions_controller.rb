class Api::CommissionsController < Api::BaseController
  before_action :default_format_json, only: [:by_year, :consolidated_by_y]
  before_action :authenticate_admin_or_api!

  def index
    @commissions = Commission.all
    @commissions = @commissions.where("partner_id = ?", params[:partner_id]).order("order_date desc") if params[:partner_id]
    paginate json: @commissions, status: 200
  end

  def by_year
    if params[:year] && params[:partner_id]
      @partner = ::Partner.find_by(id: params[:partner_id])
      @commissions = @partner.commissions_by_year(params[:year]).order(:order_date)
      respond_with do |format|
        format.json { render json: @commissions.as_json }
        format.csv { send_data @commissions.to_csv({ col_sep: "\t" }), filename: "relatorio-parceiro-#{@partner.name}-#{params[:year]}-#{Date.today}.csv" }
        format.xlsx {
          ToXlsx.new(@commissions, { titles: ["codigo", "No. Pedido", "Data da compra", "Nome do Cliente", "Valor do Pedido", "Valor pago com vale", "Enviado em", "Porcentagem", "Pontos/Produtos", "Pontos/Dinheiro", "Data envio", "Criado em", "Atualizado em"],
                                    attributes: ["id", "order_id", "order_date", "client_name", "order_price", "return_price", "percent_date", "percent", "points", "percent_value", "sent_date", "created_at", "updated_at"] }).generate
          send_file Rails.root.join("ruby.xlsx"), filename: "relatorio-parceiro-#{@partner.name}-#{params[:year]}-#{Date.today}.xlsx"
        }
      end
    else
      render json: { errors: { error: I18n.t("models.commissions.response.required_year_partner") } }, status: 422
    end
  end

  def consolidated_by_year
    if params[:year]
      @commissions = ::Partner.commissions_by_year(params[:year])
      respond_with do |format|
        format.json { render json: @commissions.limit(40).as_json }
        format.csv { send_data @commissions.to_csv({ attributes: ["nome_parceiro", "janeiro", "fevereiro", "marco", "abril", "maio", "junho", "julho", "agosto", "outubro", "novembro", "dezembro"], col_sep: "\t", default_nil: "0" }), filename: "relatorio-consolidado-parceiros-#{params[:year]}-#{Date.today}.csv" }
        format.xlsx {
          ToXlsx.new(@commissions, { titles: ["Nome do Parceiro", "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"], attributes: ["nome_parceiro", "janeiro", "fevereiro", "marco", "abril", "maio", "junho", "julho", "agosto", "outubro", "novembro", "dezembro"] }).generate
          send_file Rails.root.join("ruby.xlsx"), filename: "relatorio-consolidado-parceiros-#{params[:year]}-#{Date.today}.xlsx"
        }
      end
    else
      render json: { errors: { error: I18n.t("models.commissions.response.required_year") } }, status: 422
    end
  end

  def create
    @commission = ::Partner.find(commission_params[:partner_id]).commissions.new(commission_params.as_json(except: (:partner_id)))
    if @commission.save
      render json: @commission, status: 201
    else
      render json: { errors: @commission.errors }, status: 422
    end
  end

  def update
    @commission = Commission.find(params[:id])
    if @commission.update(commission_params)
      render json: @commission, status: 200
    else
      render json: { errors: @commission.errors }, status: 422
    end
  end

  def destroy
    @commission = Commission.find(params[:id])
    @commission.destroy
    head 204
  end

  def destroy_all
    @commissions = Commission.all
    if params[:partner_id]&.is_a?(Integer) && c = @commissions.where("partner_id = ?", params[:partner_id])
      c.destroy_all if c.size > 0
      render json: { success: "Deletado todos as comissoes do parceiro " + params[:partner_id] }, status: 204
    else
      render json: { errors: "partner_id necessario" }, status: 422
    end
  end

  private

  def default_format_json
    request.format = "json" unless params[:format]
  end

  def commission_params
    params.permit(:partner_id, :order_id, :order_date, :order_price,
                  :client_name, :return_price, :points, :percent, :percent_date, :sent_date)
  end
end
