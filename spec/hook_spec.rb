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
    let(:switch_source) { described_class.switch_source(lead) }

    it 'return with name Campinas' do
      expect(switch_source).to eq('Facebook - Rota Kawasaki - Campinas')
    end

    context 'when message comes nil' do
      before { lead.message = nil }

      it 'return the original source' do
        expect(switch_source).to eq('Facebook - Rota Kawasaki')
      end
    end

    context 'when message comes to jundiaí' do
      before { lead.message = 'em_qual_modelo_você_tem_interesse?: z400; city: Itatiba; por_qual_loja_você_deseja_ser_atendido?: jundiaí' }

      it 'return the original source' do
        expect(switch_source).to eq('Facebook - Rota Kawasaki - Jundiaí')
      end
    end

    context 'when message comes to jundiaí' do
      before { lead.message = 'em_qual_modelo_você_tem_interesse?: Nina 400; cidade: Jundiaí' }

      it 'return the original source' do
        expect(switch_source).to eq('Facebook - Rota Kawasaki - Jundiaí')
      end
    end
  end
end
