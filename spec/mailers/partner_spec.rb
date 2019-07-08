require "rails_helper"

RSpec.describe PartnerMailer, type: :mailer do
  setup do
    @partner = create(:partner)
  end

  describe "forgot_password_instruction" do
    let(:email) { PartnerMailer.forgot_password_instruction(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq([@partner.primary_email.email])
      expect(email.subject).to eq("Programa Mais Descontos: Esqueceu sua senha!")
    end
  end

  describe "new_indication" do
    let(:email) { PartnerMailer.new_indication(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["relacionamento@lojaobrafacil.com.br"])
      expect(email.subject).to eq("ObraFacil: Nova indicação!")
    end
  end

  describe "new_partner" do
    let(:email) { PartnerMailer.new_partner(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["relacionamento@lojaobrafacil.com.br"])
      expect(email.subject).to eq("ObraFacil: Novo Parceiro!")
    end
  end
end
