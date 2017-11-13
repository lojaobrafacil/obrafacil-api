class Api::V1::PermissionsController < Api::V1::BaseController

  def index
    permissions = Permission.all
    render json: permissions, status: 200
  end

  def show
    permission = Permission.find(params[:id])
    render json: permission, status: 200
  end

  def create
    permission = Permission.new(permission_params)

    if permission.save
      render json: permission, status: 201
    else
      render json: { errors: permission.errors }, status: 422
    end
  end

  def update
    permission = Permission.find(params[:id])

    if permission.update(permission_params)
      render json: permission, status: 200
    else
      render json: { errors: permission.errors }, status: 422
    end
  end

  def destroy
    permission = Permission.find(params[:id])
    permission.destroy
    head 204
  end

  private

  def permission_params
    params.require(:permission).permit(:name)
  end
end
