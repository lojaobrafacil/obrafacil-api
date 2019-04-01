class Api::UsersController < Api::BaseController
  before_action :authenticate_admin_or_api!
end
