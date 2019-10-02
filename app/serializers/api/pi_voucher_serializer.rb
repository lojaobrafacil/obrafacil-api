class Api::PiVoucherSerializer < ActiveModel::Serializer
  attributes :id, :expiration_date, :value, :used_at, :status,
             :received_at, :send_email_at, :attachment_url, :company,
             :partner, :created_at, :updated_at

  def attachment_url
    object.attachment.url
  end

  def company
    object.company.as_json(only: [:id, :name])
  end

  def partner
    object.partner.as_json(only: [:id, :name])
  end
end
