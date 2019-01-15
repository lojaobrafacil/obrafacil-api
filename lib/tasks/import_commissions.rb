module ImportByCsv
  class Commissions
    attr_accessor :inputfile, :outputfile

    def initialize(inputfile, outputfilename)
      @inputfile = File.read(inputfile)
      @extfile = File.extname(inputfile)
      @outputfile = outputfilename
    end

    def run
      if @extfile == ".csv"
        CSV.open(Rails.root.join("public", @outputfile), "wb") do |output|
        csv = CSV.parse(@inputfile, :headers => false)
        csv.each do |row|
          obj = {
            partner_id: row[0],
            order_id: row[1],
            order_date: row[2],
            order_price: row[3],
            client_name: row[4],
            points: row[5],
            percent: row[6],
            percent_date: row[7],
            sent_date: row[8],
            return_price: row[9],
          }

          @commission = Commission.new(obj)

            if @commission.save
              output << [row: obj, status: "sucesso"]
            else
              output << [row: obj, status: "error", error: @commission.errors.messages]
            end
          end
        end
      end
    end
  end
end
