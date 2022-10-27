require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when came from the website' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@rotakawasaki.f1sales.net']
      email.subject = 'Site Rota K - Nathanael Splinter - Formulário Campinas'
      email.body = "Nome: Teste Followize\nE-mail: followize@teste.com\nFone: 99212345132\nInteresse: Consórcio\nUnidade: Jundiaí\nResposta: Ligação\nMensagem: Lead teste, favor não responder\nPagina:   https://www.rotakawasaki.com.br/novos/ninja-zx-10r-2022/"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Website')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Teste Followize')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('99212345132')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('followize@teste.com')
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
      expect(parsed_email[:description]).to eq('Interesse: Consórcio - Resposta: Ligação - Unidade: Jundiaí')
    end
  end
end
