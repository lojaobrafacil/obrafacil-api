class ReportPolicy < ApplicationPolicy

  def index?
    user.change_partners || user.admin
  end
end