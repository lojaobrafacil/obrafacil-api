class Api::BaseController < ApplicationController
  include Pundit

  def pundit_user
    @current_user ||= current_api_employee
  end
end
