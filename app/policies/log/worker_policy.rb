
class Log::WorkerPolicy < ApplicationPolicy
  def sms?
    user.is_a?(Api) || user&.change_partners || user&.admin
  end
end
