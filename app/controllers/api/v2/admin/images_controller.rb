class Api::V2::Admin::ImagesController < Api::V2::Admin::BaseController
  before_action :set_product, only: [:create]

  def create
    response = []
    images_params.each do |image|
      image = @product.image_products.build(attachment: image)
      image.save ? response << image : response << image.errors
    end

    render json: { response: response }, status: 200
  end

  def destroy
    ImageProduct.find(params[:id]).destroy
    head 204
  end
  
  private
  
  def set_product
    @product = Product.find(params[:product_id])
  end  

  def images_params
    params.require(:images) # allow nested params as array
  end
end