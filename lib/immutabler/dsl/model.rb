module Immutabler
  module DSL
    class Model
      attr_accessor :name, :base, :props, :mappings

      def initialize(name, base, props, mappings)
        @name = name
        @base = base
        @props = props
        @mappings = mappings
      end
    end
  end
end
