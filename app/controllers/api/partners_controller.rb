class Api::PartnersController < Api::BaseController
  before_action :authenticate_admin_or_api!

  before_action :set_partner, only: [:show, :update, :destroy, :reset]

  def index
    @partners = ::Partner.all
    if @partners&.empty? or @partners.nil?
      render json: @partners, status: 200
    else
      @partners = if params[:name] && params[:federal_registration]
                    @partners.where("LOWER(name) LIKE LOWER(?) and federal_registration LIKE ?", "%#{params[:name]}%", "#{params[:federal_registration]}%")
                  else
                    @partners.all
                  end
      paginate json: @partners.order(:name).as_json(only: [:id, :name, :federal_registration, :state_registration, :active, :description, :cash_redemption]), status: 200
    end
  end

  def show
    render json: @partner, status: 200
  end

  def create
    @partner = ::Partner.new(partner_params)
    if @partner.save
      render json: @partner, status: 201
    else
      render json: {errors: @partner.errors}, status: 422
    end
  end

  # def reset
  #   c ||= 0
  #   p = @partner.as_json
  #   e = @partner.emails.as_json
  #   a = @partner.addresses.as_json
  #   pp = @partner.phones.as_json
  #   cc = @partner.commissions.as_json
  #   @partner.destroy
  #   if p = ::Partner.create(p)
  #     pp.each do |phone|
  #       p.phones.create(phone)
  #     end
  #     a.each do |address|
  #       p.addresses.create(address)
  #     end
  #     e.each do |email|
  #       p.emails.create(email)
  #     end
  #     cc.each do |commission|
  #       p.commissions.create(commission)
  #     end
  #     show
  #   elsif c > 3
  #     reset
  #     c += 1
  #   else
  #     render json: {errors: p.errors, partner: @partner}, status: 422
  #   end
  # end

  def update
    if @partner.update(partner_params)
      render json: @partner, status: 200
    else
      render json: {errors: @partner.errors}, status: 422
    end
  end

  def destroy
    user = @partner.user
    @partner.destroy
    user.destroy if !user.client
    head 204
  end

  private

  def set_partner
    @partner = ::Partner.find_by(id: params[:id])
    head 404 unless @partner
  end

  def partner_params
    params.permit(:name, :federal_registration, :state_registration,
                  :kind, :active, :started_date, :renewal_date, :description, :origin, :percent, :agency,
                  :ocupation, :account, :favored, :user_id, :bank_id, :discount3, :discount5, :discount8,
                  :cash_redemption, :partner_group_id)
  end
end
