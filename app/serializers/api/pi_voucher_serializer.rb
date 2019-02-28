class Api::PiVoucherSerializer < ActiveModel::Serializer
  attributes :id, :expiration_date, :value, :used_at, :status,
             :received_at, :company, :partner, :created_at, :updated_at

  def company
    object.company.as_json(only: [:id, :name])
  end

  def partner
    object.partner.as_json(only: [:id, :name])
  end
end
