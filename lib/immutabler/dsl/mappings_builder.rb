require_relative 'mapping'
require_relative 'dict_mappings_builder'

module Immutabler
  module DSL
    class MappingsBuilder
      def initialize(mappings, &block)
        @mappings = mappings
        instance_eval(&block)
      end

      def map(origin_name, destination_name, options = {})
        @mappings << Mapping.new(origin_name.to_s, destination_name.to_s, options)
      end

      def array(origin_name, destination_name, type)
        options = {
          type: type.to_s,
          array: true
        }
        @mappings << Mapping.new(origin_name.to_s, destination_name.to_s, options)
      end

      def dict(origin_name, destination_name, &block)
        mapping = Mapping.new(origin_name.to_s, destination_name.to_s, dict: true)
        DictMappingsBuilder.new(mapping.dict_mappings, &block)
        @mappings << mapping
      end
    end
  end
end
