class Api::V2::Admin::Log::PremioIdealSerializer < ActiveModel::Serializer
  attributes :id, :status, :error, :body, :partner_federal_registration, :updated_at

  def partner_federal_registration
    object.partner ? object.partner.federal_registration : nil
  end
end
