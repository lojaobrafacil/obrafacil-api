class ImagePolicy < ApplicationPolicy
  def permitted_attributes
    if user.is_a?(Api) || user.change_products || user.admin
      [:product_id, images: []]
    else
      []
    end
  end
end
