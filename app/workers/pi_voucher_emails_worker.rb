class PiVoucherEmailsWorker
  include Sidekiq::Worker

  def perform(id)
    @pi_voucher = PiVoucher.find(id)
    PiVouchersMailer.send_to_partner(@pi_voucher).deliver_now
    @pi_voucher.update(send_email_at: Time.now)
  end
end
