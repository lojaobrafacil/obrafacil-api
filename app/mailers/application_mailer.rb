class ApplicationMailer < ActionMailer::Base
  default from: "Programa Mais Descontos <naoresponda@lojaobrafacil.com.br>",
          bcc: "logs+obrafacil@bramotech.com"
  layout "mailer"
end
