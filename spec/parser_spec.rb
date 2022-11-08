require 'ostruct'
require 'byebug'
require 'faker'

RSpec.describe F1SalesCustom::Email::Parser do
  let(:customer_name) { Faker::Name.name }
  let(:customer_phone) { Faker::Number.number(digits: 11).to_s }
  let(:customer_email) { Faker::Internet.email }
  let(:store) { %w[Campinas Jundiaí].sample }

  context 'when came from the website formulário de contato' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@rotakawasaki.f1sales.net']
      email.subject = "Contato de #{customer_name} - Formulário #{store}"
      email.body = "Nome: #{customer_name}\nE-mail: #{customer_email}\nFone: #{customer_phone}\nUnidade: #{store}\nResposta: Ligação\nMensagem: Lead teste, favor não responder"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website - Contato')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq(customer_name)
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq(customer_phone)
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq(customer_email)
    end

    it 'contains product name' do
      expect(parsed_email[:product][:name]).to eq('')
    end

    it 'contains link page' do
      expect(parsed_email[:product][:link]).to eq('')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Lead teste, favor não responder')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq("Interesse:  - Resposta: Ligação - Unidade: #{store} - Formulário #{store}")
    end
  end

  context 'when came from the website formulario novos' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@rotakawasaki.f1sales.net']
      email.subject = "Site Rota K - #{customer_name} - Formulário #{store}"
      email.body = "Nome: #{customer_name}\nE-mail: #{customer_email}\nFone: #{customer_phone}\nInteresse: Consórcio\nUnidade: #{store}\nResposta: Ligação\nMensagem: Lead teste, favor não responder\nPagina:   https://www.rotakawasaki.com.br/novos/ninja-zx-10r-2022/"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website - Produto')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq(customer_name)
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq(customer_phone)
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq(customer_email)
    end

    it 'contains product name' do
      expect(parsed_email[:product][:name]).to eq('')
    end

    it 'contains link page' do
      expect(parsed_email[:product][:link]).to eq('https://www.rotakawasaki.com.br/novos/ninja-zx-10r-2022/')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Lead teste, favor não responder')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq("Interesse: Consórcio - Resposta: Ligação - Unidade: #{store} - Formulário #{store}")
    end
  end

  context 'when came from the website' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@rotakawasaki.f1sales.net']
      email.subject = 'Site Rota K - Quero Consórcio'
      email.body = "Nome: #{customer_name}\nE-mail: #{customer_email}\nFone: #{customer_phone}\nUnidade: #{store}\nResposta: Ligação\nMensagem: Lead teste, favor não responder\nPagina:   https://www.rotakawasaki.com.br/novos/ninja-zx-10r-2022/"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website - Consórcio')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq(customer_name)
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq(customer_phone)
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq(customer_email)
    end

    it 'contains product name' do
      expect(parsed_email[:product][:name]).to eq('')
    end

    it 'contains link page' do
      expect(parsed_email[:product][:link]).to eq('https://www.rotakawasaki.com.br/novos/ninja-zx-10r-2022/')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Lead teste, favor não responder')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq("Interesse:  - Resposta: Ligação - Unidade: #{store} - Quero Consórcio")
    end
  end
end
