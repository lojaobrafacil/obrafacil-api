class Api::V2::BaseController < ApplicationController
  before_action :authenticate_api_v1_user!
  include Pundit
  def pundit_user 
    current_api_v2_user
  end
  
end
