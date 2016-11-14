require_relative 'props_builder'

module Immutabler
  module DSL
    class ModelAttributesBuilder
      def initialize(props, &block)
        @props = props
        instance_eval(&block)
      end

      def fields(&block)
        PropsBuilder.new(@props, &block)
      end
    end
  end
end
