class ImagesController < Api::V1::BaseController
  before_action :set_product

  def create
    add_more_images(images_params[:images]))
    flash[:error] = "Failed uploading images" unless @product.save
    redirect_to :back
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def add_more_images(new_images)
    images = @product.images # copy the old images 
    images += new_images # concat old images with new ones
    @product.images = images # assign back
  end

  def images_params
    params.require(:product).permit({images: []}) # allow nested params as array
  end
end