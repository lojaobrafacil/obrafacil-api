class Api::V1::BaseController < ApplicationController
  # before_action :authenticate_api_v1_user!
  # before_action :authenticate_api_v1_employee!
  include Pundit
  def pundit_user 
    current_api_v1_user 
  end
  
end
