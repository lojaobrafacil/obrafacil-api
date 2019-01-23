class ToXlsx
  require "rubygems"
  require "write_xlsx"

  def initialize(object, options = {})
    @object = object.as_json
    @titles = options[:titles] rescue nil
    @attributes = options[:attributes].size rescue nil
    @filename = options[:filename] rescue nil
  end

  def generate
    workbook = WriteXLSX.new("ruby.xlsx")
    worksheet = workbook.add_worksheet
    format = workbook.add_format
    col = row = 0
    worksheet.write(row, col, @titles, format)
    @object.each do |object|
      col = 0
      row += 1
      object.values.drop(1).each do |attr|
        worksheet.write(row, col, attr, format)
        col += 1
      end
    end

    workbook.close
  end
end
