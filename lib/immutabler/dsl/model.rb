module Immutabler
  module DSL
    class Model
      attr_accessor :name, :base, :builder_base, :props, :mappings

      def initialize(name, base, builder_base, props, mappings)
        @name = name
        @base = base
        @builder_base = builder_base
        @props = props
        @mappings = mappings
      end
    end
  end
end
