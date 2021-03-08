class BaseService
  attr_reader :response, :error_message, :status_code

  def initialize
    @response = nil
    @error_message = nil
    @status_code = 200
  end

  def can_execute?
    success?
  end

  def success?
    @error_message.nil?
  end

  def call
    if can_execute?
      execute_action
    end
    success?
  end

  def add_error(message, code)
    @error_message = message
    @status_code = code

    success?
  end

  def add_success(response, code = 200)
    @response = response
    @status_code = code

    success?
  end
end
