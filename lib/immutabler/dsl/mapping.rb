module Immutabler
  module DSL
    class Mapping
      attr_accessor :origin_name, :destination_name, :type, :dict_mappings, :custom_transformer

      def initialize(origin_name, destination_name, options = {})
        @origin_name = origin_name
        @destination_name = destination_name
        @type = options[:type]
        @is_array = options.fetch(:array, false)
        @is_dict  = options.fetch(:dict,  false)
        @custom_transformer = options[:with]
        @dict_mappings = []
      end

      def array?
        @is_array
      end

      def dict?
        @is_dict
      end

      def custom?
        !custom_transformer.nil?
      end
    end
  end
end
