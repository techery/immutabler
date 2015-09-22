module Immutabler
  module DSL
    class DictMappingsBuilder
      def initialize(dict_mappings, &block)
        @dict_mappings = dict_mappings
        instance_eval(&block)
      end

      def map(origin_name, destination_name)
        dict_mapping =
          {
            origin_name: origin_name.to_s,
            destination_name: destination_name.to_s
          }
        @dict_mappings << dict_mapping
      end
    end
  end
end
