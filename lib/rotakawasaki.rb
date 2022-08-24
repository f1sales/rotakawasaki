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
        @source_name = lead.source.name
        source_name_down = @source_name.downcase
        @message = lead.message&.downcase || ''
        @description = lead.description&.downcase || ''
        return facebook_source if source_name_down['facebook']
        return followize_source if source_name_down['followize']
      end

      def facebook_source
        if @message['campinas']
          "#{@source_name} - Campinas"
        elsif @message['jundiaí']
          "#{@source_name} - Jundiaí"
        else
          @source_name
        end
      end

      def followize_source
        if @description['campinas']
          "#{@source_name} - Campinas"
        elsif @description['jundiaí']
          "#{@source_name} - Jundiaí"
        else
          @source_name
        end
      end
    end
  end
end
