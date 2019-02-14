class Api::ReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_name, :link, :updated_at, :created_at

  def link
    object.attachment.url
  end

  def user_name
    object.employee.name
  end
end
