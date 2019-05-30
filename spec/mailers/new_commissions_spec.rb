require "rails_helper"

RSpec.describe NewCommissionsMailer, type: :mailer do
  describe "notify partner" do
    let(:partner) { create(:partner) }
    let(:mail) { NewCommissionsMailer.sample_email(partner) }

    it "renders the headers" do
      expect(mail.subject).to eq("ObraFacil: Temos atualização das suas pontuações!")
      expect(mail.to).to eq([partner.primary_email.email])
      expect(mail.from).to eq(["naoresponda@lojaobrafacil.com.br"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("pontuações")
    end
  end
end
