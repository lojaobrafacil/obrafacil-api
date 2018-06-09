require 'csv'
module To_csv
  def to_csv(attributes)
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |model|
        csv << attributes.map{ |attr| model.send(attr) }
      end
    end
  end
end