class ReportPolicy < ApplicationPolicy
  def index?
    user.is_a?(Api) || user.change_partners || user.admin
  end
end
