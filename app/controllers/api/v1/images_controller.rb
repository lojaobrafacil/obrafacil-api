class Api::V1::ImagesController < Api::V1::BaseController
  before_action :set_product

  def create
    add_more_images(images_params)
    if @product.save
      response = "Upload realizado com sucesso"
    else
      response = "Falha ao fazer o upload" 
    end

    render json: { response: response }, status: 200
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def add_more_images(new_images)
    images = []
    @product.images.each do |image|
      images += [image.url]
    end
    images += [new_images[:images].tempfile]
    @product.images = images
  end

  def images_params
    params.permit(:images) # allow nested params as array
  end
end