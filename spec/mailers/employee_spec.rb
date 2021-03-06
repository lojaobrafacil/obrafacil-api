require "rails_helper"

RSpec.describe EmployeeMailer, type: :mailer do
  setup do
    @partner = create(:partner)
  end

  describe "new_partner_indication" do
    let(:email) { EmployeeMailer.new_partner_indication(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["relacionamento@lojaobrafacil.com.br"])
      expect(email.subject).to eq("ObraFacil: Nova indicação!")
    end
  end

  describe "new_partner" do
    let(:email) { EmployeeMailer.new_partner(@partner) }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["relacionamento@lojaobrafacil.com.br"])
      expect(email.subject).to eq("ObraFacil: Novo Parceiro!")
    end
  end

  describe "new_contact" do
    let(:email) {
      EmployeeMailer.new_contact({
        name: "Arthur Moura",
        email: "arthurjm95@gmail.com",
        subject: "Subject",
        phone: "",
        message: "Message Message Message Message.",
      })
    }

    it "renders the headers" do
      expect(email.from).to eq(["naoresponda@lojaobrafacil.com.br"])
      expect(email.to).to eq(["relacionamento@lojaobrafacil.com.br"])
      expect(email.reply_to).to eq(["arthurjm95@gmail.com"])
      expect(email.subject).to eq("ObraFacil: Nova contato! - Subject")
    end
  end
end
