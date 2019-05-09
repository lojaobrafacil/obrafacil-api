class Partner::BaseController < ApplicationController
  before_action :authenticate_partner_user!
end
