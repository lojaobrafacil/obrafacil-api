class ApplicationMailer < ActionMailer::Base
  BCC_MAIL = "logs@bramotech.com"
  default from: "Programa Mais Descontos' <naoresponda@lojaobrafacil.com.br>"
  layout "mailer"
end
