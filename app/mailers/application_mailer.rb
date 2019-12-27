class ApplicationMailer < ActionMailer::Base
  default from: "Programa Mais Descontos <naoresponda@lojaobrafacil.com.br>",
          bcc: "logsdoarthur+obrafacil@gmail.com"
  layout "mailer"
end
