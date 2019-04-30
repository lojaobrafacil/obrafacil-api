def new_employees
  a = Employee.create(name: "Henrique Amorim de brito",
                      description: "(vendedor) ITAIM //// endereco: Av Pres João Goulart, 03, Apto Nova Iorque 11",
                      federal_registration: "33714456821",
                      state_registration: "43846686x",
                      password: "33714456821",
                      email: "henrique@lojaobrafacil.com.br",
                      birth_date: "02/04/1986",
                      active: true)
  Phone.create(phone: "11945741115", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "José Roberto Paixão Santos",
                      description: "(vendedor) ITAIM //// endereco: AL TUCANO N 395 CASA 2  JAGUARÉ  SP",
                      federal_registration: "01423353552",
                      state_registration: "383023312",
                      password: "01423353552",
                      email: "JRPS@LOJAOBRAFACIL.COM.BR",
                      birth_date: "10/01/1981",
                      active: true)
  Phone.create(phone: "11941753035", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "SANDRO AGNALDO PRONI ALVES",
                      description: "(Encarregado da loja) PINHEIROS //// endereco: RUA JOÃO CATANI  17 B – BAIRRO JD ADRIANA – CIDADE GUARULHOS –SP",
                      federal_registration: "10115232800",
                      state_registration: "202598147",
                      password: "10115232800",
                      email: "SANDRO@LOJAOBRAFACIL.COM.BR",
                      birth_date: "12/11/1971",
                      active: true)
  Phone.create(phone: "11972906507", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "ELIEL SANTOS BARBOSA",
                      description: "(vendedor responsável pelo site) PINHEIROS //// endereco: Rua Raul dos Santos Machado, 25 AP 06 TORRE  – TAIUVA / JD HELGA  / CEP: 05794370 – SP",
                      federal_registration: "36357458805",
                      state_registration: "44721760",
                      password: "36357458805",
                      email: "venda@lojaobrafacil.com.br",
                      birth_date: "10/10/1988",
                      active: true)
  Phone.create(phone: "11964921643", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "Julio Cesar Pereira Silva",
                      description: "(vendedor) PINHEIROS //// endereco: Rua Laide Barbosa da silva,19 Pq Rebouças",
                      federal_registration: "33306629804",
                      state_registration: "419776217",
                      password: "33306629804",
                      email: "Julio@lojaobrafacil.com.br",
                      birth_date: "13/05/1985",
                      active: true)
  Phone.create(phone: "11948508472", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "Adelza Coutinho da Silva",
                      description: "(vendedora) PINHEIROS //// endereco: Rua Maria Cristina, 151 Jardim Marilú – Aldeia – Carapicuiba Cep :06343060 SP",
                      federal_registration: "30657631841",
                      state_registration: "329583104",
                      password: "30657631841",
                      email: "del@lojaobrafacil.com.br",
                      birth_date: "18/04/1981",
                      active: true)
  Phone.create(phone: "11949062350", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "ROBERTO AUGUSTO SOUTO LOPES",
                      description: "(vendedor) ZONA NORTE //// endereco: RUA JOSE ALVES IRMÃO, 200 BLOCO 1 AP 41 B",
                      federal_registration: "35732485864",
                      state_registration: "423393789",
                      password: "35732485864",
                      email: "roberto@lojaobrafacil.com.br",
                      birth_date: "06/02/1987",
                      active: true)
  Phone.create(phone: "11942530260", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "José Ricardo Lima Sandes",
                      description: "(vendedor) PINHEIROS //// endereco: Rua Estrelas e Diamantes n. 14 B Cep: 05894300",
                      federal_registration: "17334696808",
                      state_registration: "283343230",
                      password: "17334696808",
                      email: "ricardo@lojaobrafacil.com.br",
                      birth_date: "15/04/1975",
                      active: true)
  Phone.create(phone: "11985476095", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "Felipe Ramos Nascimento",
                      description: "(vendedor) ITAIM //// endereco: falta endereço",
                      federal_registration: "33425383841",
                      state_registration: "426752417",
                      password: "33425383841",
                      email: "Felipe@lojaobrafacil.com.br",
                      birth_date: "31/03/1994",
                      active: true)
  Phone.create(phone: "1137337099", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "ROSIMEIRE DE SOUSA MACEDO",
                      description: "(vendedora) PINHEIROS //// endereco: RUA MADAME CURIE,123",
                      federal_registration: "32618423852",
                      state_registration: "421431558",
                      password: "32618423852",
                      email: "ROSE@LOJAOBRAFACIL.COM.BR",
                      birth_date: "18/05/1984",
                      active: true)
  Phone.create(phone: "11998910435", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "Marcelo Marques de Medeiros",
                      description: "(vendedor) ZONA NORTE //// endereco: Rua Candido Figueiredo, 86 – CEP 02249000 – Tucuruvi  SP",
                      federal_registration: "13655628838",
                      state_registration: "188680858",
                      password: "13655628838",
                      email: "Marcelo@lojaobrafacil.com.br",
                      birth_date: "26/05/1969",
                      active: true)
  Phone.create(phone: "1122362799", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "Bruno Gomes de Toledo",
                      description: "(vendedor) PINHEIROS //// endereco: Rua Califórnia, 98 – Parque Flórida –CEP 06365-320 –Carapicuiba - SP",
                      federal_registration: " 336.065.388-20",
                      state_registration: " 35.203.739-8",
                      password: "33606538820",
                      email: "bruno@lojaobrafacil.com.br",
                      birth_date: " 31/03/86",
                      active: true)
  Phone.create(phone: "957340124", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "Lucas de Oliveira Pessina",
                      description: "(vendedor) ZONA NORTE //// endereco: Rua Voluntários da Pátria, 4280 apto 124",
                      federal_registration: "425.726.448-94",
                      state_registration: "39409337",
                      password: "42572644894",
                      email: "lucas@lojaobrafacil.com.br",
                      birth_date: "13/07/1998",
                      active: true)
  Phone.create(phone: "96186-3535", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)

  a = Employee.create(name: "Lucas Renato Bianchezi",
                      description: "(vendedor) ZONA NORTE //// endereco:  Av. Eng. Caetano Alvares, 4409",
                      federal_registration: "429.811.188-11",
                      state_registration: "43.952.491-x",
                      password: "42981118811",
                      email: "Lucas.renato@lojaobrafacil.com.br",
                      birth_date: " 08/03/1994",
                      active: true)
  Phone.create(phone: " (11) 96362-9973", phonable_id: a.id, phonable_type: "Employee", phone_type_id: PhoneType.last.id)
end
