class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend ToCsv
  def self.human_enum_name(enum_name, enum_value)
    enum_value ? I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}") : nil
  end
end
