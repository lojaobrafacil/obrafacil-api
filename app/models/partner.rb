class Partner < ApplicationRecord
  belongs_to :bank
  belongs_to :billing_type
  belongs_to :user
  enum kind: [:physical, :legal]
  enum tax_regime: [:simple, :normal, :presumed]
  enum origin: [:shop, :internet, :relationship]
  validates_presence_of :name
  include Contact

  def self.active; where("active = true").order(:id); end
  def self.inactive; where("active = false").order(:id); end

  def self.query_show
    select("partners.*, billing_types.name as billing_type_name").left_joins(:billing_type).order(:id)
  end
end
