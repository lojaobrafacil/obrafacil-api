class Product < ApplicationRecord
  belongs_to :sub_category, optional: true
  belongs_to :unit
  belongs_to :supplier
  belongs_to :deleted_by, :class_name => "Employee", :foreign_key => "deleted_by_id", optional: true
  has_many :stocks, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :images, dependent: :destroy, as: :imageable
  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :stocks, allow_destroy: true
  after_create :generate_stocks, :generate_prices
  after_save :update_prices, :generate_qrcode

  validates_presence_of :name
  enum kind: [:own, :third_party, :not_marketed]
  enum status: [:inactive, :active, :deleted]
  enum suggested_price_role: [:bigger, :less, :equal]

  mount_uploader :qrcode, QrcodeUploader

  def destroy(employee_id)
    self.update(status: "deleted", deleted_at: Time.now, deleted_by_id: employee_id)
  end

  private

  def generate_stocks
    companies = Company.all
    if !companies.empty?
      companies.each do |cp|
        cp.stocks.create(stock: 0, stock_min: 0, stock_max: 0, product: self)
      end
    end
  end

  def generate_prices
    margins = Margin.all
    if !margins.empty?
      margins.each do |m|
        m.prices.create(name: "tabela #{m.order}", value: 1, plataform: 1, product: self)
      end
    end
  end

  def update_prices
    self.prices.where.not(margin: nil).each(&:save)
  end

  def generate_qrcode
    if !self.qrcode.present?
      url = qrcode_url || "https://hubcoapp.com.br/p/#{self.id}"
      qrcode = RQRCode::QRCode.new(url)

      path = "tmp/product-qrcode-#{self.id}.png"
      IO.binwrite(path, qrcode.as_png(size: 480).to_s)
      self.update(qrcode: File.open(path), path_qrcode: url)
      File.delete(path)
    end
  end
end
