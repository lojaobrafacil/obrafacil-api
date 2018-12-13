class PricePercentagePolicy < ApplicationPolicy

  def index?
    user.is_a?(Api) || user.admin
  end

  def show?
    index?
  end

  def permitted_attributes
    if user.is_a?(Api) || user.admin
      [:price_percentages]
    end
  end

end