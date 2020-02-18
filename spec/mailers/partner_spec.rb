require "rails_helper"

RSpec.describe PartnerMailer, type: :mailer do
  setup do
    @partner = create(:partner)
  end

  describe "new_indication" do
    let(:email) { PartnerMailer.new_indication(@partner, "ClientTest") }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["#{@partner.primary_email.contact}<#{@partner.primary_email.email}>"])
      expect(email.subject).to eq("Obra Fácil Mais: Bem vindo!")
    end
  end

  describe "request_access" do
    let(:email) { PartnerMailer.request_access(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["#{@partner.primary_email.contact}<#{@partner.primary_email.email}>"])
      expect(email.subject).to eq("Obra Fácil Mais: Bem vindo!")
    end
  end

  describe "first_access" do
    let(:email) { PartnerMailer.first_access(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["#{@partner.primary_email.contact}<#{@partner.primary_email.email}>"])
      expect(email.subject).to eq("Obra Fácil Mais: Bem vindo!")
    end
  end

  describe "forgot_password_instruction" do
    let(:email) { PartnerMailer.forgot_password_instruction(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["#{@partner.primary_email.contact}<#{@partner.primary_email.email}>"])
      expect(email.subject).to eq("Obra Fácil Mais: Esqueceu sua senha!")
    end
  end
end
