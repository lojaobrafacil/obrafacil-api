class Api::V1::BaseController < ApplicationController
  # before_action :authenticate_api_v1_user!
  # before_action :authenticate_api_v1_employee!
  include Pundit
  def pundit_user 
    if current_api_v1_user 
      current_api_v1_user 
    elsif current_api_v1_employee
      current_api_v1_employee
    end
  end
  
end
