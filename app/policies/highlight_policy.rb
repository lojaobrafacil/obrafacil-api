class HighlightPolicy < ApplicationPolicy
  def show?
    scope.where(:id => record.id).exists? && user
  end

  def permitted_attributes
    [:id, :title, :subtitle, :metadata, :image, :secondaryImage, :expires_at,
     :starts_in, :status, :link, :kind, :position]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
