class PdfPiVoucher < Prawn::Document
  attr_accessor :path
  attr_accessor :voucher
  PDF_OPTIONS = {
    page_size: "A4",
    margin: [40, 75],
  }

  def initialize(voucher)
    super()
    Prawn::Font::AFM.hide_m17n_warning = true
    @voucher = voucher
    @path = Rails.root.join("tmp/voucher_#{@voucher.id}.pdf")
  end

  def render
    pdf = Prawn::Document.new(PDF_OPTIONS) do |pdf|
      pdf.image open("https://s3-sa-east-1.amazonaws.com/hubcoapp-images/obrafacil-logo.png"), width: 100, :at => [380, 90]
      pdf.move_down 30

      pdf.fill_color "225599"
      pdf.text "Obra Fácil", size: 40, style: :bold, align: :left

      pdf.move_down 30
      pdf.fill_color "40464e"
      pdf.text "Voucher - Nro. #{@voucher.id}", size: 20, style: :bold, align: :left

      pdf.move_down 30
      pdf.text "Esse voucher foi emitido para <b>#{@voucher.partner.name.strip}</b>", inline_format: true

      pdf.move_down 15
      pdf.text "Valor: #{@voucher.value_br}."

      pdf.move_down 15
      pdf.text "Data de Emissão #{@voucher.created_at.strftime("%d/%m/%Y")}."

      pdf.move_down 15
      pdf.text "Expira em #{@voucher.expiration_date.strftime("%d/%m/%Y")}."

      pdf.draw_text "O valor do voucher deverá ser usado integralmente na compra,", :at => [0, 300], :size => 10
      pdf.draw_text "Sendo assim, a compra deverá ter um valor total igual ou superior ao voucher.", :at => [0, 290], :size => 10
      pdf.draw_text "Valido somente para utilização em lojas físicas.", :at => [0, 250], :size => 10

      pdf.draw_text "https://www.lojaobrafacil.com.br", :at => [0, 0], :size => 10
      pdf.render_file(@path)
    end
  end
end
