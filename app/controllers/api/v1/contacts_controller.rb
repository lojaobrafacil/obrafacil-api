class Api::V1::ContactsController < Api::V1::BaseController


  def addresses_params
    params.require(controller).permit(:addresses_attributes => [:id, :street, :neighborhood, :zipcode, :ibge, :gia, :complement, :description, :address_type_id, :city_id, :_destroy])
  end

  def phones_params
    params.require(controller).permit(:phones_attributes => [:id, :phone, :phone_type_id, :_destroy])
  end

  def emails_params
    params.require(controller).permit(:emails_attributes => [:id, :email, :email_type_id, :_destroy])
  end

  private

  def controller
    self.controller_path.split("/").last.singularize.to_sym
  end
end
