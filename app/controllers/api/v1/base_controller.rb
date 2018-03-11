class Api::V1::BaseController < ApplicationController
  before_action :authenticate_with_token!  
end
