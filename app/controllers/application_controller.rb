class ApplicationController < ActionController::API
  Mime::Type.register "application/xlsx", :xlsx
  Mime::Type.register "application/csv", :csv
  respond_to :json, :xls, :csv
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def version
    render(json: {
             current: 200,
             minimum: 200,
             title: "HUBCO API V2",
           })
  end

  private

  def user_not_authorized
    render json: { errors: I18n.t("pundit.errors.not_autorize") }, status: 401
  end
end
