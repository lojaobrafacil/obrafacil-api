require "rails_helper"

RSpec.describe PartnerMailer, type: :mailer do
  setup do
    @partner = create(:partner)
  end

  test "forgot_password_instruction" do
    # Create the email and store it for further assertions
    email = PartnerMailer.forgot_password_instruction(@partner)

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ["naoresponda@lojaobrafacil.com.br"], email.from
    assert_equal [@partner.primary_email.email], email.to
    assert_equal "Programa Mais Descontos: Esqueceu sua senha!", email.subject
  end
end
