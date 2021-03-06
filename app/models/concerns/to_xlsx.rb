class ToXlsx
  include ActionView::Helpers::NumberHelper
  require "rubygems"
  require "write_xlsx"

  def initialize(hash, options = {})
    @hash = hash
    @attributes = @hash.class == Array ? @hash.map { |x| x.keys }.uniq[0] : options[:attributes] || hash.attribute_names rescue nil
    @titles = @hash.class == Array ? @hash.map { |x| x.keys }.uniq[0] : formatted_titles(options[:titles]) rescue formatted_titles(@attributes)
    @attributes_size = @attributes.size rescue nil
    @filename = options[:filename] rescue "ruby.xlsx"
    @template = options[:template] || @hash.class.to_s.split("::").first
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
      titles = left + [@hash.human_attribute_name(title)] + right if ["emails", "phones", "addresses"].exclude?(title)
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
    @hash.each do |object|
      col = 0
      row += 1
      @attributes.each do |attr|
        worksheet.write_string(row, col, object[attr].to_s)
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
    @hash.each do |object|
      col = 0
      row += 1
      @attributes.each do |attr|
        if attr == "emails"
          for i in 0...2
            email = object.emails[i]
            if !email.to_s.empty?
              worksheet.write_string(row, col, email.email.to_s, format)
              col += 1
              worksheet.write_string(row, col, email.email_type.name.to_s, format)
              col += 1
              worksheet.write_string(row, col, email.contact.to_s, format)
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
              worksheet.write_string(row, col, phone.formatted_phone(true).to_s, format)
              col += 1
              worksheet.write_string(row, col, phone.phone_type.name.to_s, format)
              col += 1
              worksheet.write_string(row, col, phone.contact.to_s, format)
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
              worksheet.write_string(row, col, address.street.to_s, format)
              col += 1
              worksheet.write_string(row, col, address.neighborhood.to_s, format)
              col += 1
              worksheet.write_string(row, col, address.zipcode.to_s, format)
              col += 1
              worksheet.write_string(row, col, address.ibge.to_s, format)
              col += 1
              worksheet.write_string(row, col, address.complement.to_s, format)
              col += 1
              worksheet.write_string(row, col, address.description.to_s, format)
              col += 1
              worksheet.write_string(row, col, address.address_type.name.to_s, format)
              col += 1
              worksheet.write_string(row, col, address.city.name.to_s, format)
              col += 1
            else
              col += 8
            end
          end
        end
        if attr == "attachment"
          worksheet.write_string(row, col, object.attachment_url, format.to_s)
          col += 1
        end
        if attr == "coupon"
          worksheet.write_string(row, col, object.coupon&.code.to_s, format)
          col += 1
        end
        if attr == "bank"
          worksheet.write_string(row, col, object.bank&.name.to_s, format)
          col += 1
        end
        if attr == "partner_group"
          worksheet.write_string(row, col, object.partner_group&.name.to_s, format)
          col += 1
        end
        if attr == "created_by"
          worksheet.write_string(row, col, object.created_by&.name.to_s, format)
          col += 1
        end
        if attr == "deleted_by"
          worksheet.write_string(row, col, object.deleted_by&.name.to_s, format)
          col += 1
        end
        if attr == "status"
          worksheet.write_string(row, col, Partner.human_enum_name(:status, object.status).to_s, format)
          col += 1
        end
        if attr == "kind"
          worksheet.write_string(row, col, Partner.human_enum_name(:kind, object.kind).to_s, format)
          col += 1
        end
        if attr == "origin"
          worksheet.write_string(row, col, Partner.human_enum_name(:origin, object.origin).to_s, format)
          col += 1
        end
        if attr == "cash_redemption"
          worksheet.write_string(row, col, Partner.human_enum_name(:cash_redemption, object.cash_redemption).to_s, format)
          col += 1
        end
        unless ["emails", "phones", "addresses",
                "attachment", "coupon", "bank",
                "partner_group", "created_by",
                "deleted_by", "status", "kind",
                "origin", "cash_redemption"].include?(attr)
          worksheet.write_string(row, col, object[attr].to_s, format)
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
    @hash.each do |object|
      col = 0
      row += 1
      @attributes.each do |attr|
        if attr == "nome_parceiro"
          worksheet.write_string(row, col, object[attr].to_s, format)
          col += 1
        else
          worksheet.write_string(row, col, number_to_currency(object[attr], :unit => "R$ ", :separator => ",", :delimiter => ".").to_s, format_num)
          col += 1
        end
      end
    end
    workbook.close
    Rails.root.join("tmp/#{@filename}")
  end
end
