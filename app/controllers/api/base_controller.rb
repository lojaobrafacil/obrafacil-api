class Api::BaseController < ApplicationController
  before_action :authenticate_admin_or_api!
  include Pundit
  def pundit_user
    current_user ||= current_api_employee
  end
  
end
