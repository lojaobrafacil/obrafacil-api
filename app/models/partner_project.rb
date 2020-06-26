class PartnerProject < ApplicationRecord
  validates_presence_of :name, :content, :environment
  belongs_to :partner, optional: false
  before_validation :default_values
  before_validation :validate_images, on: :update
  before_validation :generate_metadata
  has_many :project_images, dependent: :destroy
  alias_attribute :images, :project_images
  accepts_nested_attributes_for :project_images, allow_destroy: true
  enum environment: [:externo, :interno, :banheiro, :sala, :cozinha, :quarto, :suite, :varanda]
  enum status: [:em_analise, :aprovado, :reprovado]
  attr_accessor :highlight_image

  def default_values
    self.name.strip! if self.name
    self.content.strip! if self.content
    self.city.strip! if self.city
  end

  def generate_metadata(c = 1)
    if self.name_changed? || self.partner_id_changed? || self.new_record?
      metadata = "#{partner_id}-#{self.name.gsub(" ", "_")}"
      metadata = c === 1 ? metadata : "#{metadata}#{c}".downcase
      return generate_metadata(c + 1) if PartnerProject.find_by(metadata: metadata)
      self.metadata = metadata
    end
  end

  def highlight_image
    self.images.where(highlight: true).first || self.images.first
  end

  def validate_images
    errors.add(:images, "Deve conter ao menos 1 imagem") if !self.images.first && !self.new_record? && self.status != "aprovado"
  end
end
