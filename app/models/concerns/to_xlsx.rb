class ToXlsx
  require "rubygems"
  require "write_xlsx"

  def initialize(object, options = {})
    @object = object
    @titles = formatted_titles(options[:titles])
    @attributes = options[:attributes] rescue nil
    @attributes_size = options[:attributes].size rescue nil
    @filename = options[:filename] rescue "ruby.xlsx"
  end

  def generate
    workbook = WriteXLSX.new("tmp/#{@filename}")
    worksheet = workbook.add_worksheet
    format = workbook.add_format
    col = row = 0
    worksheet.write(row, col, @titles, format)
    @object.each do |object|
      col = 0
      row += 1
      @attributes.each do |attr|
        if attr == "emails"
          for i in 0...2
            email = object.emails[i]
            if email
              worksheet.write(row, col, email.email, format)
              col += 1
              worksheet.write(row, col, email.email_type.name, format)
              col += 1
              worksheet.write(row, col, email.contact, format)
              col += 1
            else
              col += 3
            end
          end
        end
        if attr == "phones"
          for i in 0...2
            phone = object.phones[i]
            if phone
              worksheet.write(row, col, phone.formatted_phone(true), format)
              col += 1
              worksheet.write(row, col, phone.phone_type.name, format)
              col += 1
              worksheet.write(row, col, phone.contact, format)
              col += 1
            else
              col += 3
            end
          end
        end
        if attr == "addresses"
          for i in 0...2
            address = object.addresses[i]
            if address
              worksheet.write(row, col, address.street, format)
              col += 1
              worksheet.write(row, col, address.neighborhood, format)
              col += 1
              worksheet.write(row, col, address.zipcode, format)
              col += 1
              worksheet.write(row, col, address.ibge, format)
              col += 1
              worksheet.write(row, col, address.complement, format)
              col += 1
              worksheet.write(row, col, address.description, format)
              col += 1
              worksheet.write(row, col, address.address_type.name, format)
              col += 1
              worksheet.write(row, col, address.city.name, format)
              col += 1
            else
              col += 8
            end
          end
        end
        if attr == "attachment"
          worksheet.write(row, col, object.attachment_url, format)
          col += 1
        end
        if attr == "coupon"
          worksheet.write(row, col, object.coupon&.code, format)
          col += 1
        end
        if attr == "bank"
          worksheet.write(row, col, object.bank&.name, format)
          col += 1
        end
        if attr == "partner_group"
          worksheet.write(row, col, object.partner_group&.name, format)
          col += 1
        end
        if attr == "created_by"
          worksheet.write(row, col, object.created_by&.name, format)
          col += 1
        end
        if attr == "deleted_by"
          worksheet.write(row, col, object.deleted_by&.name, format)
          col += 1
        end
        if attr == "status"
          worksheet.write(row, col, case object.status
          when "active"
            "Ativo"
          when "inactive"
            "Inativo"
          when "pre_active"
            "Pré Ativo"
          when "deleted"
            "Deletado"
          when "review"
            "Revisar"
          else
            ""
          end, format)
          col += 1
        end
        unless ["emails", "phones", "addresses",
                "attachment", "coupon", "bank",
                "partner_group", "created_by",
                "deleted_by", "status"].include?(attr)
          worksheet.write(row, col, object[attr].to_s, format)
          col += 1
        end
      end
    end
    workbook.close
    Rails.root.join("tmp/#{@filename}")
  end

  def formatted_titles(titles)
    if titles.include?("emails")
      left, right = titles.split("emails")
      titles = left + ["email_1", "email_type_1", "contact_1", "email_2", "email_type_2", "contact_2"] + right
    end
    if titles.include?("phones")
      left, right = titles.split("phones")
      titles = left + ["phone_1", "phone_type_1", "contact_1", "phone_2", "phone_type_2", "contact_2"] + right
    end
    if titles.include?("addresses")
      left, right = titles.split("addresses")
      titles = left + ["street_1", "neighborhood_1", "zipcode_1", "ibge_1", "complement_1", "description_1", "address_type_1", "city_1", "street_2", "neighborhood_2", "zipcode_2", "ibge_2", "complement_2", "description_2", "address_type_2", "city_2"] + right
    end
    if titles.include?("coupon")
      left, right = titles.split("coupon")
      titles = left + ["Cupom"] + right
    end
    if titles.include?("bank")
      left, right = titles.split("bank")
      titles = left + ["banco"] + right
    end
    if titles.include?("partner_group")
      left, right = titles.split("partner_group")
      titles = left + ["Grupo de parceiro"] + right
    end
    if titles.include?("created_by")
      left, right = titles.split("created_by")
      titles = left + ["Criado por"] + right
    end
    if titles.include?("deleted_by")
      left, right = titles.split("deleted_by")
      titles = left + ["Deletado por"] + right
    end
    titles
  end
end
