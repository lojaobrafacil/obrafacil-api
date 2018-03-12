class Api::V1::ContactsController < Api::V1::BaseController

  def update_contact(model)
    unless params_contact(model, :addresses).nil?
      params_contact(model, :addresses).each do |address|
        ad = address.permit(:id, :street, :neighborhood, :zipcode, :ibge, :number, :complement, :description, :address_type_id, :city_id, :_destroy)
        if ad[:id] != nil 
          ad[:_destroy] == true ? Address.find(ad[:id]).delete : Address.find(ad[:id]).update!(ad) if Address.find(ad[:id]).addressable == model
        else
          model.addresses.create!(ad)
        end
      end
    end
    unless params_contact(model, :phones).nil?
      params_contact(model, :phones).each do |phone|
        ph = phone.permit(:id, :phone, :phone_type_id, :_destroy)
        p ph
        if ph[:id] != nil
          ph[:_destroy] == true ? Phone.find(ph[:id]).delete : Phone.find(ph[:id]).update!(ph) if Phone.find(ph[:id]).phonable == model
        else
          model.phones.create!(ph)
        end
      end
    end
    unless params_contact(model, :emails).nil?
      params_contact(model, :emails).each do |email|
        em = email.permit(:id, :email, :email_type_id, :_destroy)
        if em[:id] != nil
          em[:_destroy] == true ? Email.find(em[:id]).delete : Email.find(em[:id]).update!(em) if Email.find(em[:id]).emailable == model
        else
          model.emails.create!(em)
        end
      end
    end
  end

  private 

  def params_contact(model, contact_type)
    begin
      params.require(model.class.to_s.downcase.to_sym)[contact_type] ? params.require(model.class.to_s.downcase.to_sym)[contact_type] : params.require(contact_type)
    rescue
      nil
    end
  end
end
