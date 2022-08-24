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
      expect(switch_source).to eq("#{source_name} - Campinas")
    end

    context 'when message comes nil' do
      before { lead.message = nil }

      it 'return the original source' do
        expect(switch_source).to eq(source_name)
      end
    end

    context 'when message comes to jundiaí' do
      before { lead.message = 'em_qual_modelo_você_tem_interesse?: z400; city: Itatiba; por_qual_loja_você_deseja_ser_atendido?: jundiaí' }

      it 'return the original source' do
        expect(switch_source).to eq("#{source_name} - Jundiaí")
      end
    end

    context 'when message comes to jundiaí' do
      before { lead.message = 'em_qual_modelo_você_tem_interesse?: Nina 400; cidade: Jundiaí' }

      it 'return the original source' do
        expect(switch_source).to eq("#{source_name} - Jundiaí")
      end
    end
  end

  context 'when is from Followize' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.description = 'Rota K - Jundiaí: Fluxo Loja - Telefone'

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = source_name

      source
    end

    let(:source_name) { 'Followize' }
    let(:switch_source) { described_class.switch_source(lead) }

    it 'return source Followize - Jundiaí' do
      expect(switch_source).to eq("#{source_name} - Jundiaí")
    end

    context 'when is from Campinas' do
      before { lead.description = 'Rota K - Campinas: Instagran - Vendedor - Instagram' }

      it 'return Followize - Campinas' do
        expect(switch_source).to eq("#{source_name} - Campinas")
      end
    end

    context 'when description does not have the store location' do
      before { lead.description = 'Rota K: Instagran - Vendedor - Instagram' }

      it 'return Followize - Campinas' do
        expect(switch_source).to eq("#{source_name}")
      end
    end
  end
end
