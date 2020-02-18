class ApplicationMailer < ActionMailer::Base
  default from: "Obra Fácil Mais <naoresponda@lojaobrafacil.com.br>",
          bcc: "logsdoarthur+obrafacil@gmail.com"
  layout "mailer"
end
