class Admin::ReportPolicy < Admin::ApplicationPolicyV2

  def index?
    user.change_partners || user.admin
  end
end