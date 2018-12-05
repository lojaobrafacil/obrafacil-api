class PricePercentagePolicy < ApplicationPolicy

  def index?
    user.admin
  end

  def show?
    index?
  end

  def permitted_attributes
    if user.admin
      :price_percentages
    end
  end

end