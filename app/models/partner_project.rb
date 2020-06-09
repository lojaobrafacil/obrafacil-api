class PartnerProject < ApplicationRecord
  validates_presence_of :name, :content, :environment
  belongs_to :partner, optional: false
  before_validation :default_values
  has_many :project_images, dependent: :destroy
  alias_attribute :images, :project_images
  accepts_nested_attributes_for :project_images, allow_destroy: true
  enum environment: [:externo, :interno, :banheiro, :sala, :cozinha, :quarto, :suite, :varanda]
  enum status: [:em_analise, :aprovado, :reprovado]

  def default_values
    self.name.strip! if self.name
    self.content.strip! if self.content
    self.city.strip! if self.city
    self.metadata = "#{partner_id}-#{name.split(" ").join("-")}" if self.name_changed? || self.project_date_changed?
  end
end
