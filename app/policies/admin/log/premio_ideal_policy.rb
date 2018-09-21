class Admin::Log::PremioIdealPolicy < Admin::ApplicationPolicyV2
  
  def show?
    ::Log::PremioIdeal.where(:id => record.id).exists? && user.admin
  end

  class Scope < Scope
    def resolve
      if user.change_partners || user.admin
        scope.all.order("updated_at DESC")
      else
        []
      end
    end
  end
end