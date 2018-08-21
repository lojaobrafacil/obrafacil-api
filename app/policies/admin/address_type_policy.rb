class Admin::AddressTypePolicy < Admin::ApplicationPolicyV2
  
  def show?
    AddressType.where(:id => record.id).exists? && user.admin
  end

  def permitted_attributes
    if user.admin
      [:name]
    else
      []
    end
  end
end