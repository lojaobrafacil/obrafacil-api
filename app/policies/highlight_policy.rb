class HighlightPolicy < ApplicationPolicy
  def show?
    scope.where(:id => record.id).exists? && user
  end

  def permitted_attributes
    [:id, :title_1, :title_2, :content_1, :content_2, :content_3,
     :image_1, :image_2, :image_3, :expires_at, :starts_in,
     :status, :kind, :position, :link]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
