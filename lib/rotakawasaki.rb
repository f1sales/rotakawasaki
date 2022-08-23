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
        source_name = lead.source.name
        message = lead.message&.downcase || ''
        if message['campinas']
          "#{source_name} - Campinas"
        else
          source_name
        end
      end
    end
  end
end
