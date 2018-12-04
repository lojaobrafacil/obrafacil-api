class Api::V2::Admin::BaseController < ApplicationController
  # before_action :authenticate_api_v2_admin_employee!
  include Pundit
  def pundit_user
    current_api_v2_admin_employee
  end
  
end
