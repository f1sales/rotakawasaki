# frozen_string_literal: true

require_relative 'rotakawasaki/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'

module Rotakawasaki
  class Error < StandardError; end

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

      def facebook_source
        if message['campinas']
          "#{@source_name} - Campinas"
        elsif message['jundiaí']
          "#{@source_name} - Jundiaí"
        else
          @source_name
        end
      end

      def followize_source
        if description['campinas'] || message['campinas']
          "#{@source_name} - Campinas"
        elsif description['jundiaí'] || message['jundiaí']
          "#{@source_name} - Jundiaí"
        else
          @source_name
        end
      end

      def duotalk_source
        if message['campinas']
          "#{@source_name} - Campinas"
        elsif message['jundiaí']
          "#{@source_name} - Jundiaí"
        else
          @source_name
        end
      end
    end
  end
end
