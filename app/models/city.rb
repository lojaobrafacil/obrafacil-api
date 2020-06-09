class City < ApplicationRecord
  belongs_to :state

  validates_presence_of :name
  before_save :default_values

  def default_values
    self.searcher = "#{self.state.acronym} #{I18n.transliterate(self.name)}".downcase
  end
end
