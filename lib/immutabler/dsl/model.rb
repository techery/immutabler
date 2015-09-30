module Immutabler
  module DSL
    class Model
      attr_accessor :name, :base, :base_immutable, :builder_base, :props, :mappings

      def initialize(name, base, base_immutable, builder_base, props, mappings)
        @name = name
        @base = base
        @base_immutable = base_immutable
        @builder_base = builder_base
        @props = props
        @mappings = mappings
      end
    end
  end
end
