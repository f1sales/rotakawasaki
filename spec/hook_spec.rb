require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when lead comes from Facebook' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.product = product
      lead.message = 'city: Piracicaba; em_qual_loja_você_prefere_ser_atendido?: campinas'

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = source_name

      source
    end

    let(:product) do
      product = OpenStruct.new
      product.name = nil

      product
    end

    let(:source_name) { 'Facebook - Rota Kawasaki' }
    let(:switch_source) { described_class.switch_source(lead) }

    it 'return Facebook - Rota Kawasaki - Campinas' do
      expect(switch_source).to eq("#{source_name} - Campinas")
    end

    context 'when message comes nil' do
      before { lead.message = nil }

      it 'return Facebook - Rota Kawasaki' do
        expect(switch_source).to eq(source_name)
      end
    end

    context 'when message comes with jundiaí' do
      before { lead.message = 'em_qual_modelo_você_tem_interesse?: Z400; cidade: Jundiai' }

      it 'return Facebook - Rota Kawasaki - Jundiaí' do
        expect(switch_source).to eq("#{source_name} - Jundiaí")
      end
    end

    context 'when message comes with jundiaí' do
      before { lead.message = 'em_qual_modelo_você_tem_interesse?: Nina 400; cidade: Jundiaí' }

      it 'return Facebook - Rota Kawasaki - Jundiaí' do
        expect(switch_source).to eq("#{source_name} - Jundiaí")
      end
    end

    context 'when city comes with product' do
      before { lead.message = '' }

      context 'when product name contains CAMPINAS' do
        before { product.name = 'SHOWROOM PROMOCIONAL CAMPINAS' }

        it 'return Facebook - Rota Kawasaki - Jundiaí' do
          expect(switch_source).to eq("#{source_name} - Campinas")
        end
      end

      context 'when product name contains JUNDIAÍ' do
        before { product.name = 'SHOWROOM PROMOCIONAL JUNDIAÍ' }

        it 'return Facebook - Rota Kawasaki - Jundiaí' do
          expect(switch_source).to eq("#{source_name} - Jundiaí")
        end
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

      it 'return Followize' do
        expect(switch_source).to eq(source_name)
      end
    end

    context 'when the keyword comes in the message' do
      before { lead.description = '' }

      it 'return Followize' do
        expect(switch_source).to eq(source_name)
      end

      context 'when message comes with ' do
        before { lead.message = 'url: https://www.rotakawasaki.com.br/novos/versys-650/?utm_source=google&utm_medium=cpc&utm_campaign=conversao-aquisicao-leads-google-search-institucional-versys-650&utm_content=anuncio-responsivo-&utm_term=palavras-chave-novos&gclid=CjwKCAjwm8WZBhBUEiwA178UnGTfxGs_bgKzIf8-GiNugdg9pKjNTV8piyyTqWcpWmbn5FGEq3LHHxoCj6MQAvD_BwE name: Mario me responde uma pergunta qual tempo de entrega versys 650 2023 phone: (35) 99984-6980 Telefone: (35) 99984-6980 Loja: Rota K Jundiaí Atendimento: Motocicletas landLinePhone: 35999846980 @loja: Rota K Jundiaí' }

        it 'return Followize' do
          expect(switch_source).to eq("#{source_name} - Jundiaí")
        end
      end

      context 'when message comes with ' do
        before { lead.message = 'url: https://www.rotakawasaki.com.br/?utm_source=google&utm_medium=cpc&utm_campaign=conversao-aquisicao-leads-google-search-institucional-rota-k&utm_content=anuncio-responsivo-&utm_term=palavras-chave-novos&gclid=CjwKCAjwm8WZBhBUEiwA178UnFAFEMDrRn4mAhsWCDqirHOa4BJKLa9-Netv2dZ5WQBRe_qzI9x5GxoCuIMQAvD_BwE name: Luiz phone: (19) 99410-3444 Telefone: (19) 99410-3444 Loja: Rota K Campinas Atendimento: Motocicletas landLinePhone: 19994103444 @loja: Rota K Campinas' }

        it 'return Followize' do
          expect(switch_source).to eq("#{source_name} - Campinas")
        end
      end
    end
  end

  context 'when is from Duotalk' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.message = ''

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = source_name

      source
    end

    let(:source_name) { 'Duotalk Chatbot - Vendas' }
    let(:switch_source) { described_class.switch_source(lead) }

    it 'return Duotalk' do
      expect(switch_source).to eq(source_name)
    end

    context 'when message comes with Campinas' do
      before { lead.message = 'url: NaN Mensagem: Conversa iniciada via whatsapp Nome: Marina Marketing Loja: Rota K Campinas Atendimento: Motocicletas' }

      it 'return Duotalk - Campinas' do
        expect(switch_source).to eq("#{source_name} - Campinas")
      end
    end

    context 'when message comes with Jundiaí' do
      before { lead.message = 'url: NaN Mensagem: Conversa iniciada via whatsapp Nome: Marina Marketing Loja: Rota K Jundiaí Atendimento: Motocicletas' }

      it 'return Duotalk - Jundiaí' do
        expect(switch_source).to eq("#{source_name} - Jundiaí")
      end
    end
  end

  context 'when is a different source' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = source_name

      source
    end

    let(:source_name) { 'Tartarugas Ninjas são D+' }
    let(:switch_source) { described_class.switch_source(lead) }

    it 'return original source' do
      expect(switch_source).to eq(source_name)
    end
  end
end
