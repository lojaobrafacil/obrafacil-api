class Api::V2::EmailsController < Api::V2::Partner::BaseController

  def index
    emails = Email.all
    paginate json: emails, status: 200
  end

  def show
    email = Email.find(params[:id])
    render json: email, status: 200
  end

  # emails will only be created in the associated controller
  def create
    email = Email.new(email_params)
  
    if email.save
      render json: email, status: 201
    else
      render json: { errors: email.errors }, status: 422
    end
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
