class PartnerProject < ApplicationRecord
  validates_presence_of :name, :description, :environment
  belongs_to :partner, optional: false
  before_validation :default_values
  mount_uploaders :images, ProjectImageUploader
  enum environment: [:externo, :interno, :banheiro, :sala, :cozinha, :quarto, :suite, :varanda]
  enum status: [:em_analise, :aprovado, :reprovado]

  def default_values
    self.name.strip! if self.name
    self.description.strip! if self.description
    self.city.strip! if self.city
    self.metadata = "#{partner_id}-#{name.split(" ").join("-")}" if self.name_changed? || self.project_date_changed?
  end
end
