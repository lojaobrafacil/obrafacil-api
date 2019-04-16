module PiVouchers
  class PdfService < Prawn::Document
    attr_accessor :path
    attr_accessor :voucher
    PDF_OPTIONS = {
      page_size: "A4",
      margin: [40, 75],
    }

    def initialize(voucher)
      Prawn::Font::AFM.hide_m17n_warning = true
      @voucher = voucher
      @path = "voucher_#{@voucher.id}.pdf"
      super()
    end

    def can_execute?
      @voucher ? true : add_error("Voucher is mandatory.", 404)
    end

    def success?
      @error_message.nil?
    end

    def call
      p can_execute?
      if can_execute?
        render
      end
      success?
    end

    def add_error(message, code)
      @error_message = message
      @status_code = code

      success?
    end

    def render
      begin
        pdf = Prawn::Document.new(PDF_OPTIONS) do |pdf_op|
          pdf_op.image open("https://images-americanas.b2w.io/marketplace/logo/grande/5909339000129.jpg"), width: 100, :at => [380, 90]
          pdf_op.move_down 30

          pdf_op.fill_color "225599"
          pdf_op.text "Obra Fácil", size: 40, style: :bold, align: :left

          pdf_op.move_down 30
          pdf_op.fill_color "40464e"
          pdf_op.text "Voucher - Nro. #{@voucher.id}", size: 20, style: :bold, align: :left

          pdf_op.move_down 30
          pdf_op.text "Esse voucher foi emitido para <b>#{@voucher.partner.name.strip}</b>", inline_format: true

          pdf_op.move_down 15
          pdf_op.text "Valor: #{@voucher.value_br}."

          pdf_op.move_down 15
          pdf_op.text "Data de Emissão #{@voucher.created_at.strftime("%d/%m/%Y")}."

          pdf_op.move_down 15
          pdf_op.text "Expira em #{@voucher.expiration_date.strftime("%d/%m/%Y")}."

          pdf_op.draw_text "O valor do voucher deverá ser usado integralmente na compra,", :at => [0, 300], :size => 10
          pdf_op.draw_text "Sendo assim, a compra deverá ter um valor total igual ou superior ao voucher.", :at => [0, 290], :size => 10
          pdf_op.draw_text "Valido somente para utilização em lojas físicas.", :at => [0, 250], :size => 10

          pdf_op.draw_text "https://www.lojaobrafacil.com.br", :at => [0, 0], :size => 10
        end
        tmpfile = Tempfile.new(@path)
        tmpfile.binmode
        tmpfile.write pdf.render
        @voucher.update(attachment: tmpfile)
        tmpfile.close
        tmpfile.unlink
      rescue
        return add_error({ error: "Erro ao gerar PDF, tente novamente", content: @voucher }, 404)
      end
      return { success: true, message: "Processado com sucesso", status: 200 }
    end
  end
end
