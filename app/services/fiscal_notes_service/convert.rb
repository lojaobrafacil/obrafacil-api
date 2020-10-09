module FiscalNotesService
  require "crack"
  require "json"
  require "write_xlsx"

  class Convert < BaseService
    attr_accessor :success, :errors, :content

    def initialize(zip_url)
      @zip_url = zip_url
      @path = ""
      @filename = ""
      @success = {}
      @errors = {}
      super()
    end

    def can_execute?
      File.exists? @path ? add_error("folder not found.", 404) : true
    end

    def execute_action
      @path = unzip
      @filename = @path.split("/").last + ".xlsx"
      convert
    end

    def convert
      begin
        myXLS = []

        Dir.glob(@path).each do |file|
          myJSON = Crack::XML.parse(File.read(file))
          count = 1
          next if !myJSON["nfeProc"]
          begin
            if myJSON["nfeProc"]["NFe"]["infNFe"]["det"].class == Array
              myJSON["nfeProc"]["NFe"]["infNFe"]["det"].each do |prod|
                myXLS << {
                  nota_fiscal: myJSON["nfeProc"]["NFe"]["infNFe"]["ide"]["nNF"], ##  Número da nota fiscal
                  serie: myJSON["nfeProc"]["NFe"]["infNFe"]["ide"]["serie"], ##  Série da nota fiscal
                  data_emissao: myJSON["nfeProc"]["NFe"]["infNFe"]["ide"]["dhEmi"], ##  Data de emissão da nota fiscal
                  pessoa: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["CNPJ"] ? "J" : "F", ##  Preencher com 'J' para pessoa jurídica e Preencher com 'F' para pessoa física
                  cnpj: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["CNPJ"], ##  CNPJ/CPF do emitente da nota fiscal para as notas de entrada ou destinatário da nota fiscal para as notas de saída.
                  cpf: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["CPF"], ##  CNPJ/CPF do emitente da nota fiscal para as notas de entrada ou destinatário da nota fiscal para as notas de saída.
                  inscricao: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["IE"], ##  Preencher com a inscrição estadual para pessoa jurídica ou Deixar em branco para pessoa física
                  razao_social: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["xNome"], ##  Razão Social do emitente da nota fiscal para as notas de entrada ou Razão Social do destinatário da nota fiscal para as notas de saída
                  endereco: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["xLgr"], ##  Endereço do emitente da nota fiscal para as notas de entrada ou Endereço do destinatário da nota fiscal para as notas de saída
                  numero: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["nro"], ##  Número do endereço do emitente da nota fiscal para as notas de entrada ou Número do endereço do destinatário da nota fiscal para as notas de saída
                  bairro: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["xBairro"], ##  Bairro do emitente da nota fiscal para as notas de entrada ou Bairro do destinatário da nota fiscal para as notas de saída
                  cidade: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["xMun"], ##  Cidade do emitente da nota fiscal para as notas de entrada ou Cidade do destinatário da nota fiscal para as notas de saída
                  estado: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["UF"], ##  Estado do emitente da nota fiscal para as notas de entrada ou Estado do destinatário da nota fiscal para as notas de saída
                  pais: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["xPais"], ##  Nome do Pais do emitente para as notas de entrada ou Nome do Pais do destinatário para as notas de saída
                  cfop: myJSON["nfeProc"]["NFe"]["infNFe"]["det"][0]["prod"]["CFOP"], ##  CFOP principal da nota fiscal
                  valor_nf: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vNF"], ##  Valor Total da Nota Fiscal
                  valor_produtos: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vProd"], ##  Valor dos Produtos da Nota Fiscal
                  bcalc_icms: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["cBC"], ##  Base de cálculo do ICMS da Nota Fiscal
                  valor_icms: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vICMS"], ##  Valor do ICMS da Nota Fiscal
                  bcalc_st: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vBCST"], ##  Base de Cálculo da Substituição Tributária da Nota Fiscal
                  valor_icms_st: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vST"], ##  Valor do ICMS da Substituição Tributária da Nota Fiscal
                  valor_ipi: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vIPI"], ##  Valor do IPI da Nota Fiscal
                  situacao: "", ##  Preencher com 'NC' para as Notas Canceladas. Para os demais casos deixar em branco.
                  propria: "S", ##  Preencher com 'S' para notas próprias ou 'N' para notas de terceiros.
                  modelo: myJSON["nfeProc"]["NFe"]["infNFe"]["ide"]["mod"], ##  Modelo da Nota fiscal (01, 55, 57, etc)
                  chave_nfe: myJSON["nfeProc"]["protNFe"]["infProt"]["chNFe"], ##  Chave da NF-e quando a nota fiscal for modelo 55 Itens da Nota Fiscal
                  item: count, ##  Numeração sequencial das notas fiscais
                  produto: prod["prod"]["cProd"], ##  Código do produto
                  descricao: prod["prod"]["xProd"], ##  Descrição do produto
                  medida: prod["prod"]["uCom"], ##  Sigla da unidade de medida do produto
                  ncm: prod["prod"]["NCM"], ##  Código do NCM do produto
                  qtde: prod["prod"]["qCom"], ##  Quantidade do produto
                  punit: prod["prod"]["vUnCom"], ##  Preço unitário do produto
                  ptotal: prod["prod"]["vProd"], ##  Preço total do produto
                  bcalc_icms_item: prod["imposto"]["ICMS"].values[0]["vBC"], ##  Base de cálculo do ICMS do produto
                  valor_icms_item: prod["imposto"]["ICMS"].values[0]["vICMS"], ##  Valor do ICMS do produto
                  bcalc_st_item: prod["imposto"]["ICMS"].values[0]["vBCST"], ##  Base de cálculo da substituição tributária do produto
                  valor_st_item: prod["imposto"]["ICMS"].values[0]["vICMSST"], ##  Valor da substituição tributária do produto
                  aliq_icms: prod["imposto"]["ICMS"].values[0]["pICMS"], ##  Alíquota do ICMS
                  valor_ipi_item: prod["imposto"]["IPI"] ? prod["imposto"]["IPI"]["cEnq"] == "999" ? 0 : prod["imposto"]["vIPI"] : 0, ##  Valor do IPI do produto
                  cfop_item: prod["prod"]["CFOP"], ##  CFOP do produto
                }
                count += 1
              end
            else
              myXLS << {
                nota_fiscal: myJSON["nfeProc"]["NFe"]["infNFe"]["ide"]["nNF"], ##  Número da nota fiscal
                serie: myJSON["nfeProc"]["NFe"]["infNFe"]["ide"]["serie"], ##  Série da nota fiscal
                data_emissao: myJSON["nfeProc"]["NFe"]["infNFe"]["ide"]["dhEmi"], ##  Data de emissão da nota fiscal
                pessoa: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["CNPJ"] ? "J" : "F", ##  Preencher com 'J' para pessoa jurídica e Preencher com 'F' para pessoa física
                cnpj: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["CNPJ"], ##  CNPJ/CPF do emitente da nota fiscal para as notas de entrada ou destinatário da nota fiscal para as notas de saída.
                cpf: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["CPF"], ##  CNPJ/CPF do emitente da nota fiscal para as notas de entrada ou destinatário da nota fiscal para as notas de saída.
                inscricao: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["IE"], ##  Preencher com a inscrição estadual para pessoa jurídica ou Deixar em branco para pessoa física
                razao_social: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["xNome"], ##  Razão Social do emitente da nota fiscal para as notas de entrada ou Razão Social do destinatário da nota fiscal para as notas de saída
                endereco: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["xLgr"], ##  Endereço do emitente da nota fiscal para as notas de entrada ou Endereço do destinatário da nota fiscal para as notas de saída
                numero: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["nro"], ##  Número do endereço do emitente da nota fiscal para as notas de entrada ou Número do endereço do destinatário da nota fiscal para as notas de saída
                bairro: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["xBairro"], ##  Bairro do emitente da nota fiscal para as notas de entrada ou Bairro do destinatário da nota fiscal para as notas de saída
                cidade: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["xMun"], ##  Cidade do emitente da nota fiscal para as notas de entrada ou Cidade do destinatário da nota fiscal para as notas de saída
                estado: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["UF"], ##  Estado do emitente da nota fiscal para as notas de entrada ou Estado do destinatário da nota fiscal para as notas de saída
                pais: myJSON["nfeProc"]["NFe"]["infNFe"]["emit"]["enderEmit"]["xPais"], ##  Nome do Pais do emitente para as notas de entrada ou Nome do Pais do destinatário para as notas de saída
                cfop: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["CFOP"], ##  CFOP principal da nota fiscal
                valor_nf: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vNF"], ##  Valor Total da Nota Fiscal
                valor_produtos: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vProd"], ##  Valor dos Produtos da Nota Fiscal
                bcalc_icms: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vBC"], ##  Base de cálculo do ICMS da Nota Fiscal
                valor_icms: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vICMS"], ##  Valor do ICMS da Nota Fiscal
                bcalc_st: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vBCST"], ##  Base de Cálculo da Substituição Tributária da Nota Fiscal
                valor_icms_st: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vST"], ##  Valor do ICMS da Substituição Tributária da Nota Fiscal
                valor_ipi: myJSON["nfeProc"]["NFe"]["infNFe"]["total"]["ICMSTot"]["vIPI"], ##  Valor do IPI da Nota Fiscal
                situacao: "", ##  Preencher com 'NC' para as Notas Canceladas. Para os demais casos deixar em branco.
                propria: "S", ##  Preencher com 'S' para notas próprias ou 'N' para notas de terceiros.
                modelo: myJSON["nfeProc"]["NFe"]["infNFe"]["ide"]["mod"], ##  Modelo da Nota fiscal (01, 55, 57, etc)
                chave_nfe: myJSON["nfeProc"]["protNFe"]["infProt"]["chNFe"], ##  Chave da NF-e quando a nota fiscal for modelo 55 Itens da Nota Fiscal
                item: 1, ##  Numeração sequencial das notas fiscais
                produto: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["cProd"], ##  Código do produto
                descricao: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["xProd"], ##  Descrição do produto
                medida: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["uCom"], ##  Sigla da unidade de medida do produto
                ncm: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["NCM"], ##  Código do NCM do produto
                qtde: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["qCom"], ##  Quantidade do produto
                punit: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["vUnCom"], ##  Preço unitário do produto
                ptotal: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["vProd"], ##  Preço total do produto
                bcalc_icms_item: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["imposto"]["ICMS"].values[0]["vBC"], ##  Base de cálculo do ICMS do produto
                valor_icms_item: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["imposto"]["ICMS"].values[0]["vICMS"], ##  Valor do ICMS do produto
                bcalc_st_item: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["imposto"]["ICMS"].values[0]["vBCST"], ##  Base de cálculo da substituição tributária do produto
                valor_st_item: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["imposto"]["ICMS"].values[0]["vICMSST"], ##  Valor da substituição tributária do produto
                aliq_icms: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["imposto"]["ICMS"].values[0]["pICMS"], ##  Alíquota do ICMS
                valor_ipi_item: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["imposto"]["IPI"] ? myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["imposto"]["IPI"]["cEnq"] === "999" ? 0 : myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["imposto"]["vIPI"] : 0, ##  Valor do IPI do produto
                cfop_item: myJSON["nfeProc"]["NFe"]["infNFe"]["det"]["prod"]["CFOP"], ##  CFOP do produto
              }
            end
          rescue Exception => e
            return add_error({ error: "Falha ao processar, verifique o conteudo.", content: myJSON }, 404)
          end
        end
        ToXlsx.new(myXLS.as_json, { filename: @filename }).generate
      rescue Exception => e
        ap e
        return add_error({ error: "Falha ao processar, verifique o conteudo.", content: e }, 404)
      end
      return { success: true, result: File.open(Rails.root.join(@filename)), status: 200 }
    end

    def unzip
      Zip::ZipFile.open(@zip_url) do |zip_file|
        name = zip_file.name.split("/").last.split(".zip")[0]
        zip_file.each do |f|
          f_path = File.join(f.name)
          if File.exist?(f_path)
            FileUtils.rm_rf f_path
          end
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path)
        end
      end
      return name
    end
  end
end
