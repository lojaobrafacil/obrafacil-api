class Api::V1::ImagesController < Api::V1::BaseController
  before_action :set_product, only: [:create]

  def create
    if @product.image_products.create!(attachment: images_params)
      response = "Upload realizado com sucesso"
    else
      response = "Falha ao fazer o upload" 
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