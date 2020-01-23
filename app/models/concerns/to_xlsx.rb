class ToXlsx
  include ActionView::Helpers::NumberHelper
  require "rubygems"
  require "write_xlsx"

  def initialize(object, options = {})
    @object = object
    @attributes = options[:attributes] || object.attribute_names rescue nil
    @titles = formatted_titles(options[:titles]) rescue formatted_titles(@attributes)
    @attributes_size = @attributes.size rescue nil
    @filename = options[:filename] rescue "ruby.xlsx"
    @template = options[:template] || @object.class.to_s.split("::").first
  end

  def generate
    case @template
    when "Partner"
      partner
    when "commissions_by_year"
      commissions_by_year
    else
      default
    end
  end

  def formatted_titles(titles)
    titles.each do |title|
      left, right = titles.split(title)
      titles = left + [@object.human_attribute_name(title)] + right if ["emails", "phones", "addresses"].exclude?(title)
    end
    if titles.include?("emails")
      left, right = titles.split("emails")
      titles = left + ["Email 1", "Tipo do Email 1", "Contato 1", "Email 2", "Tipo do Email 2", "Contato 2"] + right
    end
    if titles.include?("phones")
      left, right = titles.split("phones")
      titles = left + ["Telefone 1", "Tipo do Telefone 1", "Contato 1", "Telefone 2", "Tipo do Telefone 2", "Contato 2"] + right
    end
    if titles.include?("addresses")
      left, right = titles.split("addresses")
      titles = left + ["Rua 1", "Bairro 1", "Cep 1", "IBGE 1", "Complemento 1", "Descrição 1", "Tipo do endereço 1", "Cidade 1", "Rua 2", "Bairro 2", "Cep 2", "IBGE 2", "Complemento 2", "Descrição 2", "Tipo do endereço 2", "Cidade 2"] + right
    end
    titles
  end

  def default
    workbook = WriteXLSX.new("tmp/#{@filename}")
    worksheet = workbook.add_worksheet
    format = workbook.add_format
    col = row = 0
    worksheet.write(row, col, @titles, format)
    @object.each do |object|
      col = 0
      row += 1
      @attributes.each do |attr|
        worksheet.write(row, col, object[attr].to_s, format)
        col += 1
      end
    end
    workbook.close
    Rails.root.join("tmp/#{@filename}")
  end

  def partner
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
            if !email.to_s.empty?
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
            if !phone.to_s.empty?
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
            if !address.to_s.empty?
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
          worksheet.write(row, col, Partner.human_enum_name(:status, object.status), format)
          col += 1
        end
        if attr == "kind"
          worksheet.write(row, col, Partner.human_enum_name(:kind, object.kind), format)
          col += 1
        end
        if attr == "origin"
          worksheet.write(row, col, Partner.human_enum_name(:origin, object.origin), format)
          col += 1
        end
        if attr == "cash_redemption"
          worksheet.write(row, col, Partner.human_enum_name(:cash_redemption, object.cash_redemption), format)
          col += 1
        end
        unless ["emails", "phones", "addresses",
                "attachment", "coupon", "bank",
                "partner_group", "created_by",
                "deleted_by", "status", "kind",
                "origin", "cash_redemption"].include?(attr)
          worksheet.write(row, col, object[attr].to_s, format)
          col += 1
        end
      end
    end
    workbook.close
    Rails.root.join("tmp/#{@filename}")
  end

  def commissions_by_year
    workbook = WriteXLSX.new("tmp/#{@filename}")
    worksheet = workbook.add_worksheet
    format = workbook.add_format
    format_num = workbook.add_format({ 'num_format': "R$ #,##0" })
    col = row = 0
    worksheet.write(row, col, @titles, format)
    @object.each do |object|
      col = 0
      row += 1
      @attributes.each do |attr|
        if attr == "nome_parceiro"
          worksheet.write(row, col, object[attr].to_s, format)
          col += 1
        else
          worksheet.write(row, col, number_to_currency(object[attr], :unit => "R$ ", :separator => ",", :delimiter => "."), format_num)
          col += 1
        end
      end
    end
    workbook.close
    Rails.root.join("tmp/#{@filename}")
  end
end
