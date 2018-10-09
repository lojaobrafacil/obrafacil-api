class Phone < ApplicationRecord
  belongs_to :phone_type
  belongs_to :phonable, polymorphic: true
  validates :phone, format: { with: /\A(\+\d{1,2}\s)?\(\d{2}\)?[\s.-]\d{4,5}[\s.-]\d{4}\z/, message: "can't be blank. format: +XX (XX) XXXXX-XXXX OR (XX) XXXXX-XXXX OR (XX) XXXX-XXXX"}
  before_save :format_phone!

  def format_phone!
    num = self.phone
    if num&.size == 10
      formatted_num = num.insert(0, '(').insert(3, ') ').insert(9, '-')
    elsif num&.size == 11
      formatted_num = num.insert(0, '(').insert(3, ') ').insert(10, '-')
    elsif num&.slice("+") && num.size == 13
      formatted_num = num.insert(3, ' (').insert(7, ') ').insert(13, '-')
    elsif num&.slice("+") && num.size == 14
      formatted_num = num.insert(3, ' (').insert(7, ') ').insert(14, '-')
    else
      formatted_num = self.phone
    end
    self.phone = formatted_num
    true
  end
end
