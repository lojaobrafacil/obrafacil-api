require "csv"

module ToCsv
  def csv_format(attributes)
    CSV.generate(col_sep: ";", headers: true) do |csv|
      email = phone = address = false
      titles = [""].concat(attributes).drop(1)
      if attributes.include?("emails")
        email = true
        attributes.delete("emails")
        titles.delete("emails")
        titles.concat(["email_1", "email_type_id_1", "contact_1", "email_2", "email_type_id_2", "contact_2"])
      end
      if attributes.include?("phones")
        phone = true
        attributes.delete("phones")
        titles.delete("phones")
        titles.concat(["phone_1", "phone_type_id_1", "contact_1", "phone_2", "phone_type_id_2", "contact_2"])
      end
      if attributes.include?("addresses")
        address = true
        attributes.delete("addresses")
        titles.delete("addresses")
        titles.concat(["street_1", "neighborhood_1", "zipcode_1", "ibge_1", "complement_1", "description_1", "address_type_id_1", "city_id_1", "street_2", "neighborhood_2", "zipcode_2", "ibge_2", "complement_2", "description_2", "address_type_id_2", "city_id_2"])
      end
      a = email || phone || address ? titles : attributes
      csv << a

      all.each do |model|
        line = attributes.map { |attr| model.send(attr) }
        if email
          for i in 0...2
            if model.emails[i]
              line.concat([model.emails[i].send("email"), model.emails[i].send("email_type_id"), model.emails[i].send("contact")])
            else
              line.concat(["", "", ""])
            end
          end
        end
        if phone
          for i in 0...2
            if model.phones[i]
              line.concat([model.phones[i].send("phone"), model.phones[i].send("phone_type_id"), model.phones[i].send("contact")])
            else
              line.concat(["", "", ""])
            end
          end
        end
        if address
          for i in 0...2
            if model.addresses[i]
              line.concat([model.addresses[i].send("street"), model.addresses[i].send("neighborhood"), model.addresses[i].send("zipcode"), model.addresses[i].send("ibge"), model.addresses[i].send("complement"), model.addresses[i].send("description"), model.addresses[i].send("address_type_id"), model.addresses[i].send("city_id")])
            else
              line.concat(["", "", "", "", "", "", "", ""])
            end
          end
        end
        csv << line
      end
    end
  end

  def to_csv(options = {})
    attributes = options && options[:attributes] ? options[:attributes] : self.column_names
    col_sep = options && options[:col_sep] ? options[:col_sep] : ","
    CSV.generate(headers: true, col_sep: col_sep) do |csv|
      csv << attributes

      all.each do |collection|
        csv << attributes.map { |attr| collection.send(attr) }
      end
    end
  end
end
