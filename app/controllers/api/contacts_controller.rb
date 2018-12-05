class Api::ContactsController < Api::BaseController

  def update_contact(model)
    authorize model
    unless params_contact(:addresses).nil?
      params_contact(:addresses).each do |address|
        ad = address.permit(:id, :street, :neighborhood, :zipcode, :ibge, :number, :complement, :description, :address_type_id, :city_id, :_destroy)
        if ad[:id] != nil
          ad[:_destroy] ? Address.find(ad[:id]).delete : Address.find(ad[:id]).update!(ad) if Address.find(ad[:id]).addressable == model
        else
          begin
            model.addresses.create!(ad)
          rescue
            nil
          end
        end
      end
    end
    unless params_contact(:phones).nil?
      params_contact(:phones).each do |phone|
        ph = phone.permit(:id, :phone, :contact, :phone_type_id, :_destroy)
        p ph
        if ph[:id] != nil
          ph[:_destroy] ? Phone.find(ph[:id]).delete : Phone.find(ph[:id]).update!(ph) if Phone.find(ph[:id]).phonable == model
        else
          begin
            model.phones.create!(ph)
          rescue
            nil
          end
        end
      end
    end
    unless params_contact(:emails).nil?
      params_contact(:emails).each do |email|
        em = email.permit(:id, :email, :contact, :email_type_id, :_destroy)
        if em[:id] != nil
          em[:_destroy] ? Email.find(em[:id]).delete : Email.find(em[:id]).update!(em) if Email.find(em[:id]).emailable == model
        else
          begin
            model.emails.create!(em)
          rescue
            nil
          end
        end
      end
    end
  end

  private 

  def params_contact(contact_type)
    begin
      params.require(contact_type)
    rescue
      []
    end
  end
end
