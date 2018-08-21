class Admin::PricePercentagePolicy < Admin::ApplicationPolicyV2

  def index?
    user.admin
  end

  def show?
    index?
  end

  def permitted_attributes
    if user.admin
      [:price_percentages]
    else
      []
    end
  end

end