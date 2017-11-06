module Contact
  def contacts
    e = emails.select("emails.*, email_types.name as email_type_name").joins(:email_type).to_a
    p = phones.select("phones.*, phone_types.name as phone_type_name").joins(:phone_type).to_a
    a = addresses.select("addresses.*, address_types.name as address_type_name, cities.name as city_name,
      states.name as state_name").joins(:address_type, :city, "inner join states on states.id = cities.state_id").to_a
    cemails = {}
    e.each do |email|
      cemails[email.email_type_name.to_sym] = email.email
    end
    cphones = {}
    p.each do |phone|
      cphones[phone.phone_type_name.to_sym] = phone.phone
    end
    caddresses = {}
    a.each do |ad|
      caddresses[ad.address_type_name.to_sym] = {street: ad.street,
        neighborhood: ad.neighborhood,
        zipcode: ad.zipcode,
        ibge: ad.ibge,
        gia: ad.gia,
        complement: ad.complement,
        description: ad.description,
        city: ad.city_name,
        state: ad.state_name}
    end
    {emails: cemails,phones: cphones,addresses: caddresses}
  end
end
