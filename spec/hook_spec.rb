require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when lead comes from Facebook' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.message = 'city: Piracicaba; em_qual_loja_você_prefere_ser_atendido?: campinas'

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = source_name

      source
    end

    let(:source_name) { 'Facebook - Rota Kawasaki' }

    it 'return with name Campinas' do
      expect(switch_source).to eq('Facebook - Rota Kawasaki - Campinas')
    end
  end
end
