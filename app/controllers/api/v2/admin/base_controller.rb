class Api::V2::BaseController < ApplicationController
  # before_action :authenticate_api_v2_user!
  # before_action :authenticate_api_v2_employee!
  include Pundit
  def pundit_user 
    if current_api_v2_user 
      current_api_v2_user 
    elsif current_api_v2_employee
      current_api_v2_employee
    end
  end
  
end
