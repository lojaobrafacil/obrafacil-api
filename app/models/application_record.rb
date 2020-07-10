class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend ToCsv

  def self.human_enum_name(enum_name, enum_value)
    enum_value ? I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}") : nil
  end

  def formatted_phone(with_country = false)
    begin
      num = phone
      if num&.size == 13
        num = num.split("+55")[1].insert(0, "(").insert(3, ") ").insert(9, "-")
      elsif num&.size == 14
        num = num.split("+55")[1].insert(0, "(").insert(3, ") ").insert(10, "-")
      else
        num
      end
      with_country ? num.insert(0, "#{phone[0..2]} ") : num
    rescue
      phone
    end
  end
end
