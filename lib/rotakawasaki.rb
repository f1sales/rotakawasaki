# frozen_string_literal: true

require_relative 'rotakawasaki/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'
require 'f1sales_helpers'

module Rotakawasaki
  class Error < StandardError; end

  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      {
        source: source,
        customer: customer,
        product: product,
        message: lead_message,
        description: lead_description
      }
    end

    def parsed_email
      @email.body.colons_to_hash(/(#{regular_expression}).*?:/, false)
    end

    def regular_expression
      'Nome|Fone|E-mail|Pagina|Interesse|Unidade|Resposta|Mensagem'
    end

    def source
      {
        name: F1SalesCustom::Email::Source.all[0][:name]
      }
    end

    def customer
      {
        name: customer_name,
        phone: customer_phone,
        email: customer_email
      }
    end

    def customer_name
      parsed_email['nome']
    end

    def customer_phone
      parsed_email['fone']
    end

    def customer_email
      parsed_email['email']&.split&.first || ''
    end

    def product
      {
        link: product_link,
        name: ''
      }
    end

    def product_link
      parsed_email['pagina']
    end

    def lead_message
      parsed_email['mensagem']
    end

    def lead_description
      "Interesse: #{parsed_email['interesse']} - Resposta: #{parsed_email['resposta']} - Unidade: #{parsed_email['unidade']} - #{subject}"
    end

    def subject
      @email.subject.split(' - ').last
    end
  end

  class F1SalesCustom::Hooks::Lead
    class << self
      def switch_source(lead)
        @lead = lead
        @source_name = @lead.source.name
        return facebook_source if source_name_down['facebook']
        return followize_source if source_name_down['followize']
        return duotalk_source if source_name_down['duotalk']

        @source_name
      end

      def source_name_down
        @source_name.downcase
      end

      def message
        @lead.message&.downcase || ''
      end

      def description
        @lead.description&.downcase || ''
      end

      def product
        @lead.product&.name&.downcase || ''
      end

      def facebook_source
        if message['campinas'] || product['campinas']
          "#{@source_name} - Campinas"
        elsif message['jundia'] || product['jundia']
          "#{@source_name} - Jundiaí"
        else
          @source_name
        end
      end

      def followize_source
        if description['duotalk']
          nil
        elsif description['campinas'] || message['campinas']
          "#{@source_name} - Campinas"
        elsif description['jundia'] || message['jundia']
          "#{@source_name} - Jundiaí"
        else
          @source_name
        end
      end

      def duotalk_source
        if message['campinas']
          "#{@source_name} - Campinas"
        elsif message['jundia']
          "#{@source_name} - Jundiaí"
        else
          @source_name
        end
      end
    end
  end
end
