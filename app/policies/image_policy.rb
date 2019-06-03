class ImagePolicy < ApplicationPolicy
  def show?
    if user.is_a?(Api)
      user.admin?
    else
      user.change_products? || user.admin?
    end
  end

  def permitted_attributes
    if show?
      [:product_id, images: []]
    else
      []
    end
  end
end
