class ApplicationMailer < ActionMailer::Base
  default from: "Programa Mais Descontos' <naoresponda@lojaobrafacil.com.br>",
          bcc: "logs@bramotech.com"
  layout "mailer"
end
