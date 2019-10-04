require "rails_helper"

RSpec.describe PiVouchersMailer, type: :mailer do
  setup do
    @pi_voucher = create(:pi_voucher)
    @partner = @pi_voucher.partner
  end

  describe "send_to_partner" do
    let(:email) { PiVouchersMailer.send_to_partner(@pi_voucher) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["#{@partner.name}<#{@partner.primary_email.email}>"])
      expect(email.subject).to eq("Programa Mais Descontos: Bem vindo!")
    end
  end
end
