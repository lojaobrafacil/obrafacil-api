class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  extend To_csv
end
