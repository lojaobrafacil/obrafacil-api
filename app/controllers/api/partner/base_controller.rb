class Api::Partner::BaseController < ApplicationController
  before_action :authenticate_api_client_user!
  include Pundit

  def pundit_user
    current_api_client_user
  end
end
