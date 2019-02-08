class Api::ImagesController < Api::BaseController
  before_action :authenticate_admin_or_api!
  before_action :set_product, only: [:create]

  def create
    response = []
    images_params[:images].each do |image|
      image = @product.image_products.build(attachment: image)
      image.save ? response << image : response << image.errors
    end

    render json: {response: response}, status: 200
  end

  def destroy
    ImageProduct.find(params[:id]).destroy
    head 204
  end

  private

  def set_product
    @product = Product.find(images_params[:product_id])
  end

  def images_params
    params.permit(policy(ImagePolicy).permitted_attributes) # allow nested params as array
  end
end
