require_relative 'enum_attribute'

module Immutabler
  module DSL
    class EnumAttributesBuilder
      def initialize(attributes, prefix, &block)
        @attributes = attributes
        @prefix = prefix
        instance_eval(&block)
      end

      def attr(name)
        @attributes << EnumAttribute.new("#{@prefix}#{name}")
      end
    end
  end
end
