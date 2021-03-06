class Api::ImagesController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_image, only: [:destroy]

  def create
    @image = Image.new(image_params)
    if @image.save
      render json: @image, status: 201
    else
      render json: { errors: @image.errors.full_messages }, status: 422
    end
  end

  def destroy
    authorize @image
    if @image.destroy
      render json: { success: "Sucesso" }, status: 200
    else
      render json: { errors: @image.errors.full_messages }, status: 422
    end
  end

  private

  def set_image
    @image = Image.find_by(id: params[:id])
    head 404 unless @image
  end

  def image_params
    params.permit(:imageable_id, :imageable_type, :attachment, :remote_attachment_url)
  end
end
