class ApiPartner::PasswordsController < ApiPartner::BaseController
  def forgot_password
    @partner = Partner.find_by(federal_registration: params[:federal_registration], status: "active")
    if @partner
      if @partner.primary_email
        @partner.forgot_password
        render json: { success: "Enviei um email para #{@partner.primary_email.email[0..2]}...@#{@partner.primary_email.email.split("@").last} com as instruçōes necessaria. caso não receba o email entre em contato conosco t: (11) 3031-6891." }, status: 200
      else
        render json: { errors: "Olha, eu encontrei seu usuário porem ele nao possue e-mail cadastrado. entre em contato conosco para saber mais t: (11) 3031-6891." }, status: 422
      end
    else
      render json: { errors: "Não encontrado." }, status: 404
    end
  end

  def validate_to_reset_password
    @partner = Partner.find_by(reset_password_token: params[:reset_password_token], federal_registration: params[:federal_registration])
    if @partner && @partner.reset_password_sent_at > Time.now - 3.hour
      head 200
    else
      head 404
    end
  end

  def reset_password
    @partner = Partner.find_by(reset_password_token: reset_password_params[:reset_password_token], federal_registration: reset_password_params[:federal_registration])
    if @partner && @partner.reset_password_sent_at > Time.now - 3.hour
      if @partner.reset_password(reset_password_params[:password], reset_password_params[:password_confirmation])
        render json: { success: "Senha alterada com sucesso." }, status: 200
      else
        render json: { errors: "Não foi possivel finalizar operação. entre em contato conosco para saber mais t: (11) 3031-6891." }, status: 422
      end
    else
      head 404
    end
  end

  private

  def reset_password_params
    params.permit(:reset_password_token, :federal_registration, :password, :password_confirmation)
  end
end
