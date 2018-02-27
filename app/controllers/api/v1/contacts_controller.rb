class Api::V1::ContactsController < Api::V1::BaseController


  def addresses_params
    params.require(:addresses)
  end

  def phones_params
    params.require(:phones)
  end

  def emails_params
    params.require(:emails)
  end

  def update_contact(model)
    unless params[:addresses].nil? or params[:addresses]
      addresses_params.each do |address|
        ad = address.permit(:id, :street, :neighborhood, :zipcode, :ibge, :gia, :complement, :description, :address_type_id, :city_id, :_destroy)
        if ad[:id] != nil
          ad[:_destroy] == true ? Address.find(ad[:id]).delete : Address.find(ad[:id]).update!(ad)
        else
          model.addresses.create!(ad)
        end
      end
    end
    unless params[:phones].nil? or params[:phones]
      phones_params.each do |phone|
        ph = phone.permit(:id, :phone, :phone_type_id, :_destroy)
        p ph
        if ph[:id] != nil
          ph[:_destroy] == true ? Phone.find(ph[:id]).delete : Phone.find(ph[:id]).update!(ph)
        else
          model.phones.create!(ph)
        end
      end
    end
    unless params[:emails].nil? or params[:emails]
      emails_params.each do |email|
        em = email.permit(:id, :email, :email_type_id, :_destroy)
        if em[:id] != nil
          em[:_destroy] == true ? Email.find(em[:id]).delete : Email.find(em[:id]).update!(em)
        else
          model.email.create!(em)
        end
      end
    end
  end
end
