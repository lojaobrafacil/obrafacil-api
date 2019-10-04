class ReportPolicy < ApplicationPolicy
  def index?
    if user&.is_a?(Api)
      user.admin?
    else
      user.change_partners || user.admin?
    end
  end
end
