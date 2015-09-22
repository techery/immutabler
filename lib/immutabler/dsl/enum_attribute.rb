module Immutabler
  module DSL
    class EnumAttribute
      attr_accessor :name

      def initialize(name)
        @name = name
      end
    end
  end
end
