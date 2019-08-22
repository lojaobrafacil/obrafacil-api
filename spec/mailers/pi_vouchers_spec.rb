require "rails_helper"

RSpec.describe PiVouchersMailer, type: :mailer do
  setup do
    @partner = create(:partner)
  end

  describe "send_to_partner" do
    let(:email) { PiVouchersMailer.send_to_partner(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["#{@partner.primary_email.contact}<#{@partner.primary_email.email}>"])
      expect(email.subject).to eq("Programa Mais Descontos: Bem vindo!")
    end
  end
end
