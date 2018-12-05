class Api::EmailsController < Api::BaseController

  def index
    emails = Email.all
    paginate json: emails, status: 200
  end

  def show
    email = Email.find(params[:id])
    render json: email, status: 200
  end

  def update
    email = Email.find(params[:id])

    if email.update(email_params)
      render json: email, status: 200
    else
      render json: { errors: email.errors }, status: 422
    end
  end

  def destroy
    email = Email.find(params[:id])
    email.destroy
    head 204
  end

  private

  def email_params
    params.permit(:email, :contact, :email_type_id, :emailable_type, :emailable_id, :contact, :email_type_id)    
  end
end
