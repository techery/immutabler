require_relative 'props_builder'
require_relative 'mappings_builder'

module Immutabler
  module DSL
    class ModelAttributesBuilder
      def initialize(props, mappings, &block)
        @props = props
        @mappings = mappings
        instance_eval(&block)
      end

      def fields(&block)
        PropsBuilder.new(@props, &block)
      end

      def mapping(&block)
        MappingsBuilder.new(@mappings, &block)
      end
    end
  end
end
