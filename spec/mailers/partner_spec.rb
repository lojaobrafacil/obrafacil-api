require "rails_helper"

RSpec.describe PartnerMailer, type: :mailer do
  setup do
    @partner = create(:partner)
  end

  describe "welcome" do
    let(:email) { PartnerMailer.welcome(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["#{@partner.primary_email.contact}<#{@partner.primary_email.email}>"])
      expect(email.subject).to eq("Programa Mais Descontos: Bem vindo!")
    end
  end

  describe "forgot_password_instruction" do
    let(:email) { PartnerMailer.forgot_password_instruction(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["#{@partner.primary_email.contact}<#{@partner.primary_email.email}>"])
      expect(email.subject).to eq("Programa Mais Descontos: Esqueceu sua senha!")
    end
  end
end
