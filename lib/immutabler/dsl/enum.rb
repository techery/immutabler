module Immutabler
  module DSL
    class Enum
      attr_accessor :name, :attributes

      def initialize(name, attributes)
        @name = name
        @attributes = attributes
      end
    end
  end
end
