class Api::V1::BaseController < ApplicationController
  # before_action :authenticate_api_v1_user!
  include Pundit
  def current_user 
    current_api_v1_user
  end
end
